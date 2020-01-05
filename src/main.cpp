#include <newtype/new_type.hpp>

#include <gtkmm.h>

int main(int argc, char * * argv)
{
  auto application = Gtk::Application::create(argc, argv, "com.felixmorgner.3mfview");
  auto window = Gtk::Window{};

  window.set_default_size(800, 600);

  return application->run(window);
}