const path = require('path')
const webpack = require('webpack')

module.exports = {
  //devtool: 'source-map',
  context: path.join(__dirname, '/src/components'),
  entry: {
    'course-recommender': './CourseRecommender.js',
    'sign-up-component': './SignUp.js',
    'homepage-component': './Homepage.js',
    'gamsatfeedback-component': './GamsatFeedBack.js',
    'inject-react-tap-event-plugin': './injectTapEventPlugin',
    'comparison-modal': './ComparisonModal'
  },
  output: {
    path: path.join(__dirname, '/../app/assets/javascripts'),
    filename: '[name].js'
  },
  plugins: [
    new webpack.NoErrorsPlugin(),
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify('production')
      }
    }),
    new webpack.optimize.CommonsChunkPlugin({
      name: 'react-common-libs'
    })
  ],
  watch: true,
  module: {
    loaders: [
      {
        test: /\.js$/,
        loaders: ['babel'],
        include: path.join(__dirname, 'src')
      },{ test: /\.css$/, loader: "style-loader!css-loader" }
    ]
  }
}
