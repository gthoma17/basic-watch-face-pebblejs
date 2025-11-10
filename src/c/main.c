/*
 * Basic Watch Face for Pebble 2 (Diorite)
 * Displays the current time in large font
 * Supports both 12-hour and 24-hour format
 */

#include <pebble.h>

// Main window and text layer
static Window *s_main_window;
static TextLayer *s_time_layer;

// Update the time display
static void update_time() {
  // Get a tm structure
  time_t temp = time(NULL);
  struct tm *tick_time = localtime(&temp);

  // Write the current hours and minutes into a buffer
  static char buffer[8];
  
  // Use system preference for 12/24 hour format
  if (clock_is_24h_style()) {
    // 24-hour format: HH:MM
    strftime(buffer, sizeof(buffer), "%H:%M", tick_time);
  } else {
    // 12-hour format: H:MM or HH:MM
    strftime(buffer, sizeof(buffer), "%I:%M", tick_time);
  }

  // Display this time on the TextLayer
  text_layer_set_text(s_time_layer, buffer);
}

// Tick handler - called every minute
static void tick_handler(struct tm *tick_time, TimeUnits units_changed) {
  update_time();
}

// Window load handler
static void main_window_load(Window *window) {
  // Get information about the Window
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  // Create the TextLayer with specific bounds
  // Center it vertically on the screen
  int time_height = 50;
  int time_y = (bounds.size.h - time_height) / 2;
  s_time_layer = text_layer_create(
      GRect(0, time_y, bounds.size.w, time_height));

  // Set the background to clear (transparent)
  text_layer_set_background_color(s_time_layer, GColorClear);
  
  // Set the text color
  text_layer_set_text_color(s_time_layer, GColorBlack);
  
  // Set initial text
  text_layer_set_text(s_time_layer, "00:00");

  // Use a large, bold font
  text_layer_set_font(s_time_layer, fonts_get_system_font(FONT_KEY_BITHAM_42_BOLD));
  
  // Center the text
  text_layer_set_text_alignment(s_time_layer, GTextAlignmentCenter);

  // Add it as a child layer to the Window's root layer
  layer_add_child(window_layer, text_layer_get_layer(s_time_layer));
}

// Window unload handler
static void main_window_unload(Window *window) {
  // Destroy TextLayer
  text_layer_destroy(s_time_layer);
}

// Initialize the app
static void init() {
  // Create main Window element and assign to pointer
  s_main_window = window_create();

  // Set the background color
  window_set_background_color(s_main_window, GColorWhite);

  // Set handlers to manage the elements inside the Window
  window_set_window_handlers(s_main_window, (WindowHandlers) {
    .load = main_window_load,
    .unload = main_window_unload
  });

  // Show the Window on the watch, with animated=true
  window_stack_push(s_main_window, true);

  // Register with TickTimerService
  tick_timer_service_subscribe(MINUTE_UNIT, tick_handler);

  // Make sure the time is displayed from the start
  update_time();
}

// Deinitialize the app
static void deinit() {
  // Destroy Window
  window_destroy(s_main_window);
}

// Main function
int main(void) {
  init();
  app_event_loop();
  deinit();
}
