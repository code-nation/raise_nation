const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')

environment.loaders.prepend('erb', erb)
module.exports = environment

const webpack = require('webpack')

// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
});

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default'],
  })
)

environment.loaders.append("jquery", {
  test: require.resolve("jquery"),
  use: [
    { loader: "expose-loader", options: { exposes: ["$", "jQuery"] } },
  ],
});
