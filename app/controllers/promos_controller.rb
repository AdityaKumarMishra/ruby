class PromosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promo, only: [:show, :edit, :update, :destroy, :access]
  before_action :ensure_access_allowed!
  layout 'layouts/dashboard'

  def index
    if request.format.symbol == :xlsx
      if params[:filterrific].present?
        sql = 'select DISTINCT promos.*, count(DISTINCT complete_orders.*) AS co, count(DISTINCT incomplete_orders.*) AS io, users.role as role, users.first_name as user_fname, users.last_name as user_lname, COALESCE (orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at) as co_at, count(DISTINCT promo_visits.id) as promo_visit_count from promos INNER JOIN users on users.id = promos.user_id LEFT JOIN promo_visits on promo_visits.promo_id = promos.id LEFT OUTER JOIN orders_promos on orders_promos.promo_id = promos.id LEFT OUTER JOIN "orders" incomplete_orders on orders_promos.order_id = incomplete_orders.id LEFT OUTER JOIN "orders" complete_orders on orders_promos.order_id = complete_orders.id AND complete_orders.status!=0 WHERE DATE(promos.created_at) BETWEEN $1 AND $2 GROUP BY promos.id, users.role, users.first_name, users.last_name, COALESCE (orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at) ORDER BY promos.created_at DESC'
        bindings = [[nil,params[:filterrific][:with_start].to_date || Promo.first.created_at.to_date],[nil, params[:filterrific][:with_end].to_date || Date.today]]
        @promos = ActiveRecord::Base.connection.exec_query(sql, 'SQL', bindings)
      else
        sql = 'select DISTINCT promos.*, count(DISTINCT complete_orders.*) AS co, count(DISTINCT incomplete_orders.*) AS io, users.role as role, users.first_name as user_fname, users.last_name as user_lname, COALESCE (orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at) as co_at,count(DISTINCT promo_visits.id) as promo_visit_count from promos INNER JOIN users on users.id = promos.user_id LEFT JOIN promo_visits on promo_visits.promo_id = promos.id LEFT OUTER JOIN orders_promos on orders_promos.promo_id = promos.id LEFT OUTER JOIN "orders" incomplete_orders on orders_promos.order_id = incomplete_orders.id LEFT OUTER JOIN "orders" complete_orders on orders_promos.order_id = complete_orders.id AND complete_orders.status!=0  GROUP BY promos.id, users.role, users.first_name, users.last_name, COALESCE (orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at) ORDER BY promos.created_at DESC'
        @promos = ActiveRecord::Base.connection.execute(sql)
      end
      @all_promos = @promos
      #{ActiveRecord::Base.sanitize(f1)}"
    else
      @promos = Promo.includes(:user).order('promos.created_at DESC').references(:users, :orders)

      (@filterrific = initialize_filterrific(
          @promos,
          params[:filterrific]
      )) || return

      @promos = @filterrific.find.order(created_at: :desc).paginate(page: params[:page], per_page: 20)
      @all_promos = @filterrific.find
    end
    date = "#{Date.today}"
    respond_to do |format|
      format.html
      format.js
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Promo Details - ' + date + '.xlsx"'
      }
    end
  end

  def used_promos
    if params[:filterrific].values.reject(&:blank?).present?
      sql = 'select DISTINCT promos.*, count(DISTINCT complete_orders.*) AS co, count(DISTINCT incomplete_orders.*) AS io, users.role as role, users.first_name as user_fname, users.last_name as user_lname, COALESCE (orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at) as co_at, count(DISTINCT promo_visits.id) as promo_visit_count from promos INNER JOIN users on users.id = promos.user_id LEFT JOIN promo_visits on promo_visits.promo_id = promos.id INNER JOIN orders_promos on orders_promos.promo_id = promos.id INNER JOIN "orders" incomplete_orders on orders_promos.order_id = incomplete_orders.id INNER JOIN "orders" complete_orders on orders_promos.order_id = complete_orders.id AND complete_orders.status!=0 WHERE DATE(COALESCE(orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at)) BETWEEN $1 AND $2 GROUP BY promos.id, users.role, users.first_name, users.last_name, COALESCE (orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at) ORDER BY COALESCE(orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at) DESC'
        bindings = [[nil,params[:filterrific][:with_start].to_date || Order.first.created_at.to_date],[nil, params[:filterrific][:with_end].to_date || Date.today]]
        @promos = ActiveRecord::Base.connection.exec_query(sql, 'SQL', bindings)
    else
      sql = 'select DISTINCT promos.*, count(DISTINCT complete_orders.*) AS co, count(DISTINCT incomplete_orders.*) AS io, users.role as role, users.first_name as user_fname, users.last_name as user_lname, COALESCE (orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at) as co_at, count(DISTINCT promo_visits.id) as promo_visit_count from promos INNER JOIN users on users.id = promos.user_id LEFT JOIN promo_visits on promo_visits.promo_id = promos.id INNER JOIN orders_promos on orders_promos.promo_id = promos.id INNER JOIN "orders" incomplete_orders on orders_promos.order_id = incomplete_orders.id INNER JOIN "orders" complete_orders on orders_promos.order_id = complete_orders.id AND complete_orders.status!=0  GROUP BY promos.id, users.role, users.first_name, users.last_name, COALESCE (orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at) ORDER BY COALESCE(orders_promos.created_at, complete_orders.paid_at, complete_orders.updated_at) DESC'
      @promos = ActiveRecord::Base.connection.execute(sql)
    end
    date = "#{Date.today}"
    respond_to do |format|
      format.html
      format.js
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Promo Details - ' + date + '.xlsx"'
      }
    end
  end

  def show
  end

  def new
    @promo = Promo.new
  end

  def edit
    authorize(@promo)
  end

  def create
    @promo = Promo.new(promo_params)
    @promo.user = current_user
    authorize(@promo)
    respond_to do |format|
      if @promo.save
        @promo.generate_token! if @promo.token.blank?

        format.html { redirect_to @promo, notice: 'Promo was successfully created.' }
        format.json { render :show, status: :created, location: @promo }
      else
        format.html { render :new }
        format.json { render json: @promo.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def update
    authorize(@promo)
    respond_to do |format|
      if @promo.update(promo_params)
        @promo.generate_token! if @promo.token.blank?

        format.html { redirect_to @promo, notice: 'Promo was successfully updated.' }
        format.json { render :show, status: :ok, location: @promo }
      else
        format.html { render :edit }
        format.json { render json: @promo.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
    authorize(@promo)
    @promo.destroy
    respond_to do |format|
      format.html { redirect_to promos_url, notice: 'Promo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def ensure_access_allowed!
    user_not_authorized unless [:manager, :admin, :superadmin].include? current_user.role.to_sym
  end

    def set_promo
      @promo = Promo.find(params[:id])
    end

    def promo_params
      params.require(:promo).permit(:name, :token, :stackable, :strategy, :amount, :purchaseable_id, :purchaseable_type, :used_times, :expiry_date, :product_version_id)
    end
end
