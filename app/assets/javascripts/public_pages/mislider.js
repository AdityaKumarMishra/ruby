(function(e,i,s,t,n){var a=function(s,n){var a=this
a.optionsInit={speed:700,pause:10000000000000000,increment:1,stageHeight:false,slidesOnStage:1,slidesContinuous:true,slidePosition:"left",slideStart:"beg",slideWidth:false,slideScaling:100,offsetV:0,centerV:false,navList:true,navButtons:true,navButtonsShow:false,navButtonsOpacity:.5,randomize:false,slidesLoaded:false,beforeTrans:false,afterTrans:false,classStage:"mis-stage",classSlider:"mis-slider",classSlide:"mis-slide",classNavButtons:"mis-nav-buttons",classNavList:"mis-nav-list",selectorSlider:"ol",selectorSlide:"li",modernizrBool:false}
a.options={}
a.stage=false
a.slider=false
a.slides=false
a.navButtons=false
a.prev=false
a.next=false
a.navList=false
a.navListItems=false
a.slideCurrent=false
a.animatedElements=e()
a.stageWidth=0
a.stageHeight=0
a.sliderWidth=0
a.slideWidth=0
a.slideWidthCurrent=0
a.slideScaling=a.optionsInit.slideScaling
a.scalingWidth=0
a.scalingMargin=0
a.offsetV=a.optionsInit.offsetV
a.slidesLengthOrig=0
a.slidesLength=0
a.indexCurrent=0
a.indexFirst=0
a.indexLast=0
a.increment=a.optionsInit.increment
a.slidesOnStage=a.optionsInit.slidesOnStage
a.speed=a.optionsInit.speed
a.navButtonsOpacity=a.optionsInit.navButtonsOpacity
a.navButtonsFade=false
a.slidesContinuous=a.optionsInit.slidesContinuous
a.pause=a.optionsInit.pause
a.timer=false
a.resizeTimer=false
a.after=false
a.classSlideClone="mis-clone"
a.classSlideContainer="mis-container"
a.classCurrent="mis-current"
a.classPrev="mis-prev"
a.classNext="mis-next"
a.init=function(s,n){a.options=e.extend({},a.optionsInit,n)
a.stage=e(s)
a.stage.fadeTo(0,0)
a.slider=a.stage.children(a.options.selectorSlider).first()
a.slides=a.slider.children(a.options.selectorSlide)
a.slidesLengthOrig=a.slides.length
a.animatedElements=a.animatedElements.add(a.slider)
if(String(a.options.slideStart)==="beg"){a.indexCurrent=0}else if(String(a.options.slideStart)==="mid"){a.indexCurrent=t.ceil(a.slidesLengthOrig/2)-1}else if(String(a.options.slideStart)==="end"){a.indexCurrent=a.slidesLengthOrig-1}else if(e.isNumeric(a.options.slideStart)&&parseInt(a.options.slideStart)<=a.slidesLengthOrig&&parseInt(a.options.slideStart)>0){a.indexCurrent=parseInt(a.options.slideStart)-1}else{a.indexCurrent=0}if(a.options.randomize){a.randomize()}if(!a.stage.hasClass(a.options.classStage)){a.stage.addClass(a.options.classStage)}if(!a.slider.hasClass(a.options.classSlider)){a.slider.addClass(a.options.classSlider)}if(a.options.speed&&e.isNumeric(a.options.speed)){a.speed=t.abs(parseInt(a.options.speed))}if(a.options.pause===false){a.pause=false}else if(e.isNumeric(a.options.pause)){a.pause=t.abs(parseInt(a.options.pause))}if(e.isNumeric(a.options.offsetV)){a.offsetV=Number(a.options.offsetV)}if(e.isNumeric(a.options.navButtonsOpacity)&&Number(a.options.navButtonsOpacity)>=0&&Number(a.options.navButtonsOpacity)<=1){a.navButtonsOpacity=Number(a.options.navButtonsOpacity)}if(e.isNumeric(a.options.slideScaling)&&Number(a.options.slideScaling)>=100){a.slideScaling=Number(a.options.slideScaling)}if(!a.supportTransform(a.options.modernizrBool,s)){a.slideScaling=100}a.optionsInit.slideScaling=a.slideScaling
if(e.isNumeric(a.options.increment)&&parseInt(a.options.increment)!==0){a.increment=parseInt(a.options.increment)
a.optionsInit.increment=a.increment}if(a.options.navButtons){a.addNavButtons(a.stage)
a.animatedElements=a.animatedElements.add(a.navButtons)
if(!a.options.navButtonsShow){a.navButtonsFade=true}}if(a.options.navList){a.addNavList()}a.setup()
if(a.slidesOnStage>1){a.slider.on("click",a.options.selectorSlide,function(i){if(e(this).index()!==a.indexCurrent){i.preventDefault()
a.autoplayOff()
a.transition(e(this).index(),false,a.autoplayOn(a.increment))}})}if(a.pause!==false||a.navButtonsFade){a.stage.on({mouseenter:function(){if(a.pause!==false){a.autoplayOff()}if(a.navButtonsFade){if(!a.animatedElements.is(":animated")){a.navButtons.fadeTo(400,a.navButtonsOpacity)}else{if(e.isFunction(a.after)){var i=a.after
a.after=function(){i()
a.navButtons.fadeTo(400,a.navButtonsOpacity)}}else{a.after=function(){a.navButtons.fadeTo(400,a.navButtonsOpacity)}}}}},mouseleave:function(){if(a.pause!==false){a.autoplayOn(a.increment)}if(a.navButtonsFade){a.navButtons.fadeTo(100,0)}}})}e(i).on({load:function(){a.slideSetup()
a.updateNavButtons()
a.stage.fadeTo(600,1)
a.autoplayOn(a.increment)
if(e.isFunction(a.options.slidesLoaded)){a.options.slidesLoaded()}},resize:function(){a.autoplayOff()
clearTimeout(a.resizeTimer)
a.resizeTimer=setTimeout(function(){a.resetSlider()},500)}})
return this}
a.setup=function(){a.slidesLength=a.slidesLengthOrig
a.indexLast=a.slidesLength-1
a.slides.each(function(){var i=e(this)
if(!i.hasClass(a.options.classSlide)){i.addClass(a.options.classSlide)}if(!i.children().hasClass(a.classSlideContainer)){i.wrapInner('<div class="'+a.classSlideContainer+'"></div>')}var s=i.outerWidth()
var t=i.outerHeight()
if(s>a.slideWidthCurrent){a.slideWidthCurrent=s}if(t>a.stageHeight){a.stageHeight=t}})
if(e.isNumeric(a.options.slideWidth)&&parseInt(a.options.slideWidth)>0){a.slideWidthCurrent=parseInt(a.options.slideWidth)}if(e.isNumeric(a.options.stageHeight)&&parseInt(a.options.stageHeight)>0){a.stageHeight=parseInt(a.options.stageHeight)}a.indexCurrent=a.normalizeIndex(a.indexCurrent)
a.stage.css({height:a.stageHeight})
a.stageWidth=a.stage.outerWidth()
var i=t.floor((a.stageWidth-a.slideWidthCurrent)/(a.slideWidthCurrent*100/a.slideScaling))+1
i=i<1?1:i
a.slidesOnStage=i
if(e.isNumeric(a.options.slidesOnStage)&&parseInt(a.options.slidesOnStage)>=1&&parseInt(a.options.slidesOnStage)<=i){a.slidesOnStage=parseInt(a.options.slidesOnStage)}if(a.options.slidePosition==="center"){a.slidesOnStage=t.ceil(a.slidesOnStage/2)*2-1}var s=(a.increment+a.slidesOnStage)/2
if(s>a.slidesOnStage){a.increment=a.slidesOnStage}else if(s<0){a.increment=-a.slidesOnStage}if(a.slidesOnStage>1){a.slideWidth=(a.stageWidth-a.slideWidthCurrent)/(a.slidesOnStage-1)
if(a.slideWidthCurrent<a.slideWidth&&!a.options.slideWidth){a.slideWidth=a.stageWidth/a.slidesOnStage
a.slideWidthCurrent=a.slideWidth}}else{a.slideWidth=a.stageWidth
a.slideWidthCurrent=a.slideWidth
a.slideScaling=100}a.scalingWidth=a.slideWidth*a.slideScaling/100
a.scalingMargin=(a.slideWidth-a.scalingWidth)/2
var n=a.slidesLengthOrig-a.slidesOnStage
if(n>=0&&a.options.slidesContinuous){a.slidesContinuous=true
a.slidesToClone=a.slidesOnStage+t.abs(a.increment)-1
a.slides.slice(a.slidesLength-a.slidesToClone).clone().addClass(a.classSlideClone).removeAttr("id").prependTo(a.slider).find("*").removeAttr("id")
a.slides.slice(0,a.slidesToClone).clone().addClass(a.classSlideClone).removeAttr("id").appendTo(a.slider).find("*").removeAttr("id")
a.indexFirst=a.slidesToClone
a.indexLast=a.slidesLength+a.slidesToClone-1
a.indexCurrent=a.indexCurrent+a.slidesToClone
a.slides=a.slider.children(a.options.selectorSlide)
a.slidesLength=a.slides.length}else{a.slidesContinuous=false}a.slideCurrent=a.slides.eq(a.indexCurrent)
a.animatedElements=a.animatedElements.add(a.slides)
a.sliderWidth=a.slideWidthCurrent+a.slideWidth*(a.slidesLength-1)+1
a.slider.css({left:a.leftOffset(a.indexCurrent),width:a.sliderWidth})
a.updateNavList(a.indexCurrent)
return this}
a.transition=function(i,s,t,n){if(!a.animatedElements.is(":animated")&&i!==a.indexCurrent){var r=i
var l=a.indexCurrent
if(a.slidesContinuous){if(i<a.indexFirst){r=i+a.slidesLengthOrig}else if(i>a.indexLast){r=i-a.slidesLengthOrig}if(r!==i){l=a.indexCurrent+a.slidesLengthOrig
if(r<i){l=a.indexCurrent-a.slidesLengthOrig}}}else{r=a.normalizeIndex(i)}var d=a.normalizeIndex(r)-a.normalizeIndex(l)
if(d){if(e.isFunction(s)){s()}if(e.isFunction(a.options.beforeTrans)){a.options.beforeTrans()}var o=function(){if(e.isFunction(t)){t()}if(e.isFunction(a.options.afterTrans)){a.options.afterTrans()}if(e.isFunction(a.after)){a.after()
a.after=false}}
if(a.slidesContinuous&&l!==a.indexCurrent){var u=a.slides.eq(l)
if(a.slideScaling!==100){u.css({transform:"scale(1)",width:a.slideWidthCurrent,marginLeft:"0",marginRight:"0",borderSpacing:"100px"})
if(a.options.centerV){u.children().first().css("marginTop",u.data("slideMarginTopCurrent"))}}u.addClass(a.classCurrent).siblings().removeClass(a.classCurrent)
a.slider.css("left",a.leftOffset(l))
if(a.slideScaling!==100){a.slideCurrent.css({transform:"scale("+100/a.slideScaling+")",width:a.scalingWidth,marginLeft:a.scalingMargin,marginRight:a.scalingMargin,borderSpacing:a.slideScaling})
if(a.options.centerV){a.slideCurrent.children().first().css("marginTop",a.slideCurrent.data("slideMarginTop"))}}a.indexCurrent=l
a.slideCurrent=a.slides.eq(a.indexCurrent)}if(a.navButtons){a.navButtons.fadeTo(100,n?a.navButtonsOpacity:0,function(){a.navButtons.fadeTo(100,0,function(){a.animateSlides(r,function(){if(a.stage.find(":hover").length||a.options.navButtonsShow){a.navButtons.fadeTo(400,a.navButtonsOpacity,o)}else{o()}})})})}else{a.animateSlides(r,o)}}}return this}
a.animateSlides=function(i,s){a.slideCurrent.removeClass(a.classCurrent)
var t=a.slides.eq(i)
if(a.slideScaling!==100){t.animate({marginLeft:"0",marginRight:"0",width:a.slideWidthCurrent},{duration:a.speed,queue:false}).animate({borderSpacing:"100px"},{step:function(i){e(this).css({transform:"scale("+100/i+")"})},duration:a.speed,queue:false})
a.slideCurrent.animate({marginLeft:a.scalingMargin,marginRight:a.scalingMargin,width:a.scalingWidth},{duration:a.speed,queue:false}).animate({borderSpacing:a.slideScaling},{step:function(i){e(this).css({transform:"scale("+100/i+")"})},duration:a.speed,queue:false})
if(a.options.centerV){t.children().first().animate({marginTop:t.data("slideMarginTopCurrent")},{duration:a.speed,queue:false})
a.slideCurrent.children().first().animate({marginTop:a.slideCurrent.data("slideMarginTop")},{duration:a.speed,queue:false})}}a.slider.animate({left:a.leftOffset(i)},{duration:a.speed,queue:false,complete:function(){a.indexCurrent=i
a.slideCurrent=t
a.updateNavList(i)
a.slideCurrent.addClass(a.classCurrent).siblings().removeClass(a.classCurrent)
if(e.isFunction(s)){s()}}})
return this}
a.autoplayOn=function(e){if(a.pause!==false){a.timer=clearInterval(a.timer)
if(!a.stage.find(":hover").length){a.timer=setInterval(function(){if(!a.animatedElements.is(":animated")){a.transition(a.indexCurrent+e)}},a.pause)}}return this}
a.autoplayOff=function(){a.timer=clearInterval(a.timer)
return this}
a.addNavButtons=function(i){var s=e(i)
var n=e('<div class="'+a.options.classNavButtons+'"><a href="#" class="'+a.classPrev+'">Prev</a><a href="#" class="'+a.classNext+'">Next</a></div>')
n.css({opacity:a.options.navButtonsShow?a.navButtonsOpacity:0}).children("a").on("click",function(e){e.preventDefault()
if(this.className===a.classPrev){a.autoplayOff()
a.transition(a.indexCurrent-t.abs(a.increment),false,a.autoplayOn(a.increment),true)}else if(this.className===a.classNext){a.autoplayOff()
a.transition(a.indexCurrent+t.abs(a.increment),false,a.autoplayOn(a.increment),true)}})
s.append(n)
a.navButtons=s.find("."+a.options.classNavButtons)
a.prev=a.navButtons.find("."+a.classPrev)
a.next=a.navButtons.find("."+a.classNext)
return this}
a.updateNavButtons=function(){if(a.navButtons){a.navButtons.css({width:a.slideWidthCurrent,left:a.slideCurrent.offset().left-a.stage.offset().left}).children("a").css({height:a.stageHeight,paddingTop:(50+a.offsetV)*a.stageHeight/100})}}
a.addNavList=function(){var i='<ol class="'+a.options.classNavList+'">'
a.slides.each(function(s){var t=s+1
var n=e(this).find(":header").sort(function(i,s){var t=e(i).prop("tagName"),n=e(s).prop("tagName")
return parseInt(t.match(/\d+/),10)-parseInt(n.match(/\d+/),10)}).eq(0).html()
if(n){t=n}else{n=e(this).find("figcaption").eq(0).html()
if(n){t=n}else{n=e(this).find("img").eq(0).attr("title")
if(n){t=n}}}i+='<li><a href="#" title="'+t+'">'+t+"</a></li>"})
i+="</ol>"
var s=e(i).on("click","li",function(i){i.preventDefault()
if(e(this).index()!==a.indexCurrent-a.indexFirst){a.autoplayOff()
a.transition(e(this).index()+a.indexFirst,false,a.autoplayOn(a.increment))}})
a.stage.prepend(s)
a.navList=a.stage.children().first()
a.navListItems=a.navList.children("li")
return this}
a.updateNavList=function(e){if(a.navListItems.length){a.navListItems.eq(e-a.indexFirst).addClass(a.classCurrent).siblings().removeClass(a.classCurrent)}}
a.randomize=function(){a.slides.sort(function(){return.5-t.random()})
a.slides.detach().appendTo(a.slider)
return this}
a.leftOffset=function(e){var i=a.slideWidth*e*-1
var s=i
if(a.options.slidePosition==="center"){s=i+t.floor(a.slidesOnStage/2)*a.slideWidth}else if(a.options.slidePosition==="right"){s=i+(a.slidesOnStage-1)*a.slideWidth}return s}
a.resetSlider=function(){if(a.animatedElements.is(":animated")){if(e.isFunction(a.after)){var i=a.after
a.after=function(){i()
a.resetSlider}}else{a.after=a.resetSlider}}else{a.autoplayOff()
a.stage.removeAttr("style")
a.slider.removeAttr("style")
a.slides.removeAttr("style")
a.slides.filter("."+a.classSlideClone).remove()
a.slides=a.slider.children(a.options.selectorSlide)
a.stageHeight=0
a.slideWidthCurrent=0
a.slideScaling=a.optionsInit.slideScaling
a.indexCurrent-=a.slidesToClone
a.indexFirst=0
a.increment=a.optionsInit.increment
a.after=false
a.setup()
a.slideSetup()
a.updateNavButtons()
a.autoplayOn(a.increment)}return this}
a.normalizeIndex=function(e){e=(e%a.slidesLengthOrig+a.slidesLengthOrig)%a.slidesLengthOrig
return e}
a.slideSetup=function(){a.slides.each(function(i){var s=e(this)
s.css({"transform-origin":"50% "+String(50+a.offsetV)+"%",width:a.slideWidthCurrent})
if(a.options.centerV){a.getMarginTop(s,"slideMarginTopCurrent")}s.css({width:a.scalingWidth})
if(a.slideScaling!==100){s.css({marginLeft:a.scalingMargin,marginRight:a.scalingMargin,transform:"scale("+100/a.slideScaling+")",borderSpacing:a.slideScaling})}if(a.options.centerV){s.children().first().css("marginTop",a.getMarginTop(s,"slideMarginTop"))}if(i===a.indexCurrent){s.css({borderSpacing:"100px",width:a.slideWidthCurrent,marginLeft:0,marginRight:0,transform:"scale(1)"}).addClass(a.classCurrent).siblings().removeClass(a.classCurrent)
if(a.options.centerV){s.children().first().css("marginTop",a.getMarginTop(s,"slideMarginTopCurrent"))}}})}
a.getMarginTop=function(e,i){var s=0
var t=e.children().first().outerHeight()
if(t>a.stageHeight){s=(a.stageHeight-t)/2}e.data(i,s)
return s}
a.supportTransform=function(e,i){var s=false
if(e&&Modernizr){if(Modernizr.csstransforms){s=true}}else{var t=i.style
if(typeof t.transform!=="undefined"||typeof t.WebkitTransform!=="undefined"||typeof t.msTransform!=="undefined"){s=true}}return s}
a.init(s,n)
return this}
e.fn.miSlider=function(i){return this.each(function(){var s=e(this)
if(!s.data("miSlider")){s.data("miSlider",new a(this,i))}})}})(jQuery,window,document,Math)
