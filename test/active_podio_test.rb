require 'test_helper'

class ActivePodioTest < Test::Unit::TestCase

  # TODO - following still needs to be tested:
  # - delegate_to_hash
  # - handle_api_errors_for
  # - member, list and collection
  # - persisted?, new_record? and to_param
  # - constructor (with edge case values)
  # - ==, hash and as_json

  class TestAssociationModel
    include ActivePodio::Base
    
    property :string, :string
  end

  class TestModel
    include ActivePodio::Base
    
    property :string, :string
    property :hash, :hash
    property :datetime, :datetime
    property :date, :date
    property :integer, :integer
    property :boolean, :boolean
    property :array, :array
    
    has_one :association, :class => TestAssociationModel
    has_one :different_association, :class => TestAssociationModel, :property => :other_association
    has_many :associations, :class => TestAssociationModel
    has_many :different_associations, :class => TestAssociationModel, :property => :other_associations
  end
  
  test 'should instansiate model' do
    @test = TestModel.new
    assert_not_nil @test
  end
  
  test 'should support string property' do
    @test = TestModel.new(:string => 'string')
    assert_equal 'string', @test.string
  end

  test 'should support hash property' do
    @test = TestModel.new(:hash => { :key => 'value' })
    assert_equal({ :key => 'value' }, @test.hash)
  end
  
  test 'should store given datetime as a db string internally' do
    @test = TestModel.new(:datetime => DateTime.new(2011, 6, 7, 22, 5, 0))
    assert_equal '2011-06-07 22:05:00', @test[:datetime]
  end

  test 'should expose datetime string as datetime' do
    @test = TestModel.new(:datetime => '2011-06-07 22:05:00')
    assert_equal DateTime.new(2011, 6, 7, 22, 5, 0), @test.datetime
  end

  test 'should store given date as a db string internally' do
    @test = TestModel.new(:date => Date.new(2011, 6, 7))
    assert_equal '2011-06-07', @test[:date]
  end

  test 'should expose date string as date' do
    @test = TestModel.new(:date => '2011-06-07')
    assert_equal Date.new(2011, 6, 7), @test.date
  end
  
  test 'should store given integer string as integer internally' do
    @test = TestModel.new(:integer => "42")
    assert_equal 42, @test[:integer]
  end

  test 'should expose blank integer string as nil' do
    @test = TestModel.new(:integer => "")
    assert_nil @test.integer
  end
  
  [true, 'true', 1, '1', 'yes'].each do |boolean_value|
    test "should store and expose given boolean value #{boolean_value} (#{boolean_value.class.name}) as true" do
      @test = TestModel.new(:boolean => boolean_value)
      assert_equal true, @test.boolean
    end
  end

  [false, 'false', 0, '0', 'no', 'whatever'].each do |boolean_value|
    test "should store and expose given boolean value #{boolean_value} (#{boolean_value.class.name}) as false" do
      @test = TestModel.new(:boolean => boolean_value)
      assert_equal false, @test.boolean
    end
  end
  
  test "should expose singular array getter" do
    @test = TestModel.new(:array => ['foo', 'bar'])
    assert_equal ['foo', 'bar'], @test.array
  end

  test "should expose singular array setter" do
    @test = TestModel.new
    @test.array = ['foo', 'bar']
    assert_equal ['foo', 'bar'], @test.array
  end

  test "should expose plural array getter" do
    @test = TestModel.new(:array => ['foo', 'bar'])
    assert_equal ['foo', 'bar'], @test.arrays
  end

  test "should expose plural array setter" do
    @test = TestModel.new
    @test.arrays = ['foo', 'bar']
    assert_equal ['foo', 'bar'], @test.arrays
  end

  test "should expose default array getter" do
    @test = TestModel.new(:array => ['foo', 'bar'])
    assert_equal 'foo', @test.default_array
  end
  
  test 'should expose has one association' do
    @test = TestModel.new(:association => { :string => 'association string' })
    assert_equal 'association string', @test.association.string
  end

  test 'should expose nil has one association when no data given' do
    @test = TestModel.new
    assert_nil @test.association
  end

  test 'should use property option when given to has one association' do
    @test = TestModel.new(:other_association => { :string => 'other association' })
    assert_equal 'other association', @test.different_association.string
  end

  test 'should expose has many association' do
    @test = TestModel.new(:associations => [{ :string => 'association string 1' }, { :string => 'association string 2' }])
    assert_equal 'association string 1', @test.associations[0].string
    assert_equal 'association string 2', @test.associations[1].string
  end

  test 'should expose empty has many association when no data given' do
    @test = TestModel.new
    assert_equal [], @test.associations
  end

  test 'should use property option when given to has many association' do
    @test = TestModel.new(:other_associations => [{ :string => 'other association 1' }, { :string => 'other association 2' }])
    assert_equal 'other association 1', @test.different_associations[0].string
    assert_equal 'other association 2', @test.different_associations[1].string
  end
  
end