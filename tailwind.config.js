const colors = require("tailwindcss/colors");

module.exports = {
  plugins: [require("@tailwindcss/forms")],
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./config/locales/**/*.yml",
  ],

  theme: {
    container: {
      padding: "1rem",
    },
    colors: {
      ...colors,
      primary: {
        DEFAULT: "#1B2128",
        50: "#E8E7F8",
        100: "#D2D0F1",
        200: "#A9A4E4",
        300: "#7C75D6",
        400: "#4F46C8",
        500: "#0F172A",
        600: "#2C2682",
        700: "#221D62",
        800: "#171443",
        900: "#0B0920",
      },
    },
  },
};
