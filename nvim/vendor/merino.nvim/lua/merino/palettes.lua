-- Source: theme-studio/themes/Merino Dark and Merino Light.
-- ANSI indices are zero-based, matching the original terminal themes.
local M = {
  dark = {
    background = "#0d1117",
    foreground = "#e6edf3",
    cursor = "#2f81f7",
    cursor_text = "#6fc1ff",
    selection_background = "#e6edf3",
    selection_foreground = "#0d1117",
    ansi = {
      [0] = "#484f58", "#ff7b72", "#3fb950", "#d29922",
      "#58a6ff", "#bc8cff", "#39c5cf", "#b1bac4",
      "#6e7681", "#ffa198", "#56d364", "#e3b341",
      "#79c0ff", "#d2a8ff", "#56d4dd", "#ffffff",
    },
  },
  light = {
    background = "#ffffff",
    foreground = "#1f2328",
    cursor = "#0969da",
    cursor_text = "#3c9cff",
    selection_background = "#1f2328",
    selection_foreground = "#ffffff",
    ansi = {
      [0] = "#24292f", "#cf222e", "#116329", "#4d2d00",
      "#0969da", "#8250df", "#1b7c83", "#6e7781",
      "#57606a", "#a40e26", "#1a7f37", "#633c01",
      "#218bff", "#a475f9", "#3192aa", "#8c959f",
    },
  },
}

return M
