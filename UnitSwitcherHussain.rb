# Unit Switcher Plugin - Hussain
# Author: Hussain
# Created: October 2024
# Description: This SketchUp plugin allows users to toggle between inches and millimeters
#              with a visual floating dialog box that displays the current unit. The box
#              is styled with rounded corners, subtle transparency, and color-coded text
#              (red for inches, blue for millimeters).
#
# License: MIT License (or another license if you prefer)

module UnitSwitcherHussain
  @dialog = nil

  def self.create_dialog
    # Create a new dialog with a frameless, slim appearance
    if @dialog.nil?
      @dialog = UI::HtmlDialog.new(
        {
          :dialog_title => "Unit Switcher",
          :preferences_key => "com.sketchup.unit_switcher_hussain",
          :scrollable => false,
          :resizable => false,
          :width => 140,  # Adjust size
          :height => 75,  # Adjust height for a slim appearance
          :style => UI::HtmlDialog::STYLE_DIALOG # Frameless style for a slim, borderless look
        }
      )
    end
  end

  def self.update_dialog(unit, color)
    # Create the dialog if it hasn't been created yet
    create_dialog

    # Check if dialog is initialized and valid
    if @dialog
      html_content = <<-HTML
        <html>
        <head>
          <style>
            body { font-family: Arial, sans-serif; text-align: center; margin: 0; padding: 0; background-color: transparent; } /* Slim and clean styling */
            .status { font-size: 18px; color: black; font-weight: bold; }
            .unit { color: #{color}; font-weight: bold; }
            .container {
              padding: 10px;
              background-color: rgba(255, 255, 255, 0.8);  /* Slight transparency */
              border-radius: 18px; /* Rounded corners for a clean look */
              box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2); /* Subtle shadow */
            }
          </style>
        </head>
        <body>
          <div class="container">
            <span class="status">Unit: </span><span class="unit">#{unit}</span>
          </div>
        </body>
        </html>
      HTML

      # Set the HTML content and show the dialog
      @dialog.set_html(html_content)
      @dialog.show
    else
      puts "Dialog not initialized properly."
    end
  end

  def self.switch_units
    model = Sketchup.active_model
    options_provider = model.options["UnitsOptions"]

    current_unit = options_provider["LengthUnit"]

    # Check the current unit: 0 is inches, 2 is millimeters
    if current_unit == 0
      # Switch to Millimeters (2) and set blue color
      options_provider["LengthUnit"] = 2
      update_dialog("MM", "blue")
      puts "Switched to Millimeters"
    elsif current_unit == 2
      # Switch back to Inches (0) and set red color
      options_provider["LengthUnit"] = 0
      update_dialog("INCH", "red")
      puts "Switched to Inches"
    else
      update_dialog("Unsupported Unit", "black")
      puts "Currently using unsupported units."
    end
  end
end

# Add the menu item under Plugins and create the dialog
unless file_loaded?(__FILE__)
  UI.menu("Plugins").add_item("Unit Switcher - Hussain") {
    UnitSwitcherHussain.switch_units
  }
  file_loaded(__FILE__)
end
