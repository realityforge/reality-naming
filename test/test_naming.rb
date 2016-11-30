require File.expand_path('../helper', __FILE__)

class TestNaming < Reality::Naming::TestCase
  def test_pluralize
    assert_equal 'cats', Reality::Naming.pluralize('cat')
    assert_equal 'cats', Reality::Naming.pluralize(:cat)
    assert_equal 'poppies', Reality::Naming.pluralize('poppy')
    assert_equal 'says', Reality::Naming.pluralize('say')
    assert_equal 'foos', Reality::Naming.pluralize('foo')
  end

  def test_conversions
    perform_check(:camelize, 'mySupportLibrary')
    perform_check(:pascal_case, 'MySupportLibrary')
    perform_check(:xmlize, 'my-support-library')
    perform_check(:underscore, 'my_support_library')
    perform_check(:jsonize, 'mySupportLibrary')
    perform_check(:jsonize, 'mySupportLibrary')
    perform_check(:uppercase_constantize, 'MY_SUPPORT_LIBRARY')
  end

  def perform_check(method_name, result)
    assert_equal result, Reality::Naming.send(method_name, 'MySupportLibrary'), "Checking conversion to #{result}"
    assert_equal result, Reality::Naming.send(method_name, 'my_support_library'), "Checking conversion to #{result}"
    assert_equal result, Reality::Naming.send(method_name, 'my-support-library'), "Checking conversion to #{result}"
    assert_equal result, Reality::Naming.send(method_name, :'MySupportLibrary'), "Checking conversion to #{result}"
    assert_equal result, Reality::Naming.send(method_name, :'my_support_library'), "Checking conversion to #{result}"
    assert_equal result, Reality::Naming.send(method_name, :'my-support-library'), "Checking conversion to #{result}"
    assert_equal Reality::Naming.send(:"#{method_name}?", result), true
  end
end