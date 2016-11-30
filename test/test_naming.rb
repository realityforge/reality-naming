require File.expand_path('../helper', __FILE__)

class TestNaming < Reality::Naming::TestCase
  def test_pluralize
    assert_equal 'cats', Reality::Naming.pluralize('cat')
    assert_equal 'cats', Reality::Naming.pluralize(:cat)
    assert_equal 'poppies', Reality::Naming.pluralize('poppy')
    assert_equal 'says', Reality::Naming.pluralize('say')
    assert_equal 'foos', Reality::Naming.pluralize('foo')
  end

  def test_custom_pluralization_rules
    assert_equal 'heros', Reality::Naming.pluralize('hero')
    assert_equal 'cats', Reality::Naming.pluralize('cat')
    Reality::Naming.add_pluralization_rule do |string|
      string == 'hero' ? 'heroes' : nil
    end
    assert_equal 'heroes', Reality::Naming.pluralize('hero')
    assert_equal 'cats', Reality::Naming.pluralize('cat')
    Reality::Naming.add_pluralization_rule do |string|
      string == 'cat' ? 'catz' : nil
    end
    assert_equal 'heroes', Reality::Naming.pluralize('hero')
    assert_equal 'catz', Reality::Naming.pluralize('cat')
    Reality::Naming.clear_pluralization_rules
    assert_equal 'heros', Reality::Naming.pluralize('hero')
    assert_equal 'cats', Reality::Naming.pluralize('cat')
  end

  def test_split_into_words
    assert_equal %w(my Support Library), Reality::Naming.split_into_words('mySupportLibrary')
    assert_equal %w(My Support Library), Reality::Naming.split_into_words('MySupportLibrary')
    assert_equal %w(my support library), Reality::Naming.split_into_words('my-support-library')
    assert_equal %w(my support library), Reality::Naming.split_into_words('my_support_library')
    assert_equal %w(MY SUPPORT LIBRARY), Reality::Naming.split_into_words('MY_SUPPORT_LIBRARY')
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
