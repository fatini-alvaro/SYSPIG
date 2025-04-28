const { colors } = require('./src/styles/colors'); // Importe as cores

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,jsx,ts,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: colors.primary,
        secondary: colors.secondary,
        background: colors.background,
        surface: colors.surface,
        error: colors.error,
        onPrimary: colors.onPrimary,
        onSecondary: colors.onSecondary,
        onBackground: colors.onBackground,
        onSurface: colors.onSurface,
        success: colors.success,
      },
    },
  },
  plugins: [],
}
