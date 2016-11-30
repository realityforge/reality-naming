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

  def test_basics
    assert_equal Reality::Naming.camelize('thisIsCamelCased'), 'thisIsCamelCased'
    assert_equal Reality::Naming.camelize('ThisIsCamelCased'), 'thisIsCamelCased'
    assert_equal Reality::Naming.camelize('this_Is_Camel_Cased'), 'thisIsCamelCased'
    assert_equal Reality::Naming.camelize('this_Is_camel_cased'), 'thisIsCamelCased'
    assert_equal Reality::Naming.camelize('EJB'), 'ejb'
    assert_equal Reality::Naming.camelize('EJBContainer'), 'ejbContainer'

    assert_equal Reality::Naming.pascal_case('thisIsCamelCased'), 'ThisIsCamelCased'
    assert_equal Reality::Naming.pascal_case('ThisIsCamelCased'), 'ThisIsCamelCased'
    assert_equal Reality::Naming.pascal_case('this_Is_Camel_Cased'), 'ThisIsCamelCased'
    assert_equal Reality::Naming.pascal_case('this_Is_camel_cased'), 'ThisIsCamelCased'
    assert_equal Reality::Naming.pascal_case('EJB'), 'EJB'
    assert_equal Reality::Naming.pascal_case('EJBContainer'), 'EJBContainer'

    assert_equal Reality::Naming.pascal_case?('FindByID'), true

    assert_equal Reality::Naming.underscore('thisIsCamelCased'), 'this_is_camel_cased'
    assert_equal Reality::Naming.underscore('ThisIsCamelCased'), 'this_is_camel_cased'
    assert_equal Reality::Naming.underscore('this_Is_Camel_Cased'), 'this_is_camel_cased'
    assert_equal Reality::Naming.underscore('this_Is_camel_cased'), 'this_is_camel_cased'
    assert_equal Reality::Naming.underscore('EJB'), 'ejb'
    assert_equal Reality::Naming.underscore('EJBContainer'), 'ejb_container'

    assert_equal Reality::Naming.uppercase_constantize('thisIsCamelCased'), 'THIS_IS_CAMEL_CASED'
    assert_equal Reality::Naming.uppercase_constantize('ThisIsCamelCased'), 'THIS_IS_CAMEL_CASED'
    assert_equal Reality::Naming.uppercase_constantize('this_Is_Camel_Cased'), 'THIS_IS_CAMEL_CASED'
    assert_equal Reality::Naming.uppercase_constantize('this_Is_camel_cased'), 'THIS_IS_CAMEL_CASED'
    assert_equal Reality::Naming.uppercase_constantize('EJB'), 'EJB'
    assert_equal Reality::Naming.uppercase_constantize('EJBContainer'), 'EJB_CONTAINER'

    assert_equal Reality::Naming.xmlize('thisIsCamelCased'), 'this-is-camel-cased'
    assert_equal Reality::Naming.xmlize('ThisIsCamelCased'), 'this-is-camel-cased'
    assert_equal Reality::Naming.xmlize('this_Is_Camel_Cased'), 'this-is-camel-cased'
    assert_equal Reality::Naming.xmlize('this_Is_camel_cased'), 'this-is-camel-cased'
    assert_equal Reality::Naming.xmlize('EJB'), 'ejb'
    assert_equal Reality::Naming.xmlize('EJBContainer'), 'ejb-container'

    assert_equal Reality::Naming.jsonize('thisIsCamelCased'), 'thisIsCamelCased'
    assert_equal Reality::Naming.jsonize('ThisIsCamelCased'), 'thisIsCamelCased'
    assert_equal Reality::Naming.jsonize('this_Is_Camel_Cased'), 'thisIsCamelCased'
    assert_equal Reality::Naming.jsonize('this_Is_camel_cased'), 'thisIsCamelCased'
    assert_equal Reality::Naming.jsonize('EJB'), 'ejb'
    assert_equal Reality::Naming.jsonize('EJBContainer'), 'ejbContainer'
  end

  def test_split_into_words
    assert_equal %w(my Support Library), Reality::Naming.split_into_words('mySupportLibrary')
    assert_equal %w(My Support Library), Reality::Naming.split_into_words('MySupportLibrary')
    assert_equal %w(my support library), Reality::Naming.split_into_words('my-support-library')
    assert_equal %w(my support library), Reality::Naming.split_into_words('my_support_library')
    assert_equal %w(MY SUPPORT LIBRARY), Reality::Naming.split_into_words('MY_SUPPORT_LIBRARY')

    # ID is specially handled
    assert_equal %w(Find By ID), Reality::Naming.split_into_words('FindByID')
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
