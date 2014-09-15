require File.expand_path(File.join(File.dirname(__FILE__), 'helpers'))

class SchemaTest < Minitest::Test
  def test_dereference_with_ref
    key, value = user_input_schema.dereference({
      '$ref' => '#/definitions/user/definitions/id'
    })
    assert_equal(key,   '#/definitions/user/definitions/id')
    assert_equal(value, user_input_schema['definitions']['user']['definitions']['id'])
  end

  def test_dereference_without_ref
    key, value = user_input_schema.dereference('#/definitions/user/definitions/id')
    assert_equal(key,   '#/definitions/user/definitions/id')
    assert_equal(value, user_input_schema['definitions']['user']['definitions']['id'])
  end

  def test_dereference_with_nested_ref
    key, value = user_input_schema.dereference({
      '$ref' => '#/definitions/user/definitions/identity'
    })
    assert_equal(key,   '#/definitions/user/definitions/id')
    assert_equal(value, user_input_schema['definitions']['user']['definitions']['id'])
  end

  def test_dereference_with_overridable_values
    key, value = user_input_schema.dereference({
      '$ref' => '#/definitions/user/properties',
      'id' => {
        'example' => 'my-custom-override-id'
      }
    })
    assert_equal(value['id']['$ref'],    '#/definitions/user/definitions/id')
    assert_equal(value['id']['example'], 'my-custom-override-id')
  end

  def test_dereference_with_local_context
    key, value = user_input_schema.dereference({
      '$ref'     => '#/definitions/user/properties/id',
      'override' => true
    })
    assert_equal(key,   '#/definitions/user/definitions/id')
    assert_equal(value, {'override' => true}.merge(user_input_schema['definitions']['user']['definitions']['id']))
  end
end
