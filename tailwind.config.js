/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*_view.gleam"],
  theme: {
    extend: {
      colors: {
        'ground': '#121212',
        'surface': {
          100: '#1e1e1e',
          200: '#353535',
          300: '#7e7e7e'
        },
        'primary': '#ffb647',
        'secondary': '#ffbd5a',
        'tertiary': '#ffcc80',
        'success': '#4dd664',
        'error': '#d3543c'
      },
    },
  },
  plugins: [],
}

