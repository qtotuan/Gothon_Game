require "Gothon_Game/map.rb"
require "test/unit"

class TestGame < Test::Unit::TestCase
  include Map

  def test_escape_pod
    assert_equal(THE_END_WINNER, ESCAPE_POD.paths['2'])
    assert_equal(THE_END_LOSER, ESCAPE_POD.paths['*'])
  end

  def test_the_bridge
    assert_equal(GENERIC_DEATH, THE_BRIDGE.paths['throw the bomb'])
    assert_equal(ESCAPE_POD, THE_BRIDGE.paths['slowly place the bomb'])
  end

  def test_laser_weapon_armory
    assert_equal(THE_BRIDGE, LASER_WEAPON_ARMORY.paths['5'])
  end

  def test_central_corridor
    assert_equal(LASER_WEAPON_ARMORY, CENTRAL_CORRIDOR.paths['tell a joke'])
    assert_equal(GENERIC_DEATH, CENTRAL_CORRIDOR.paths['shoot!'])
    assert_equal(GENERIC_DEATH, CENTRAL_CORRIDOR.paths['dodge!'])
  end

  def test_generic_death
    assert_equal(GENERIC_DEATH.name, 'death')
    assert_equal(GENERIC_DEATH.description, 'You died.')
    assert_equal(GENERIC_DEATH.paths, {})
  end

  def test_session_loading
    session = {}

    room = Map::load_room(session)
    assert_equal(nil, room)

    Map::save_room(session, Map::START)
    room = Map::load_room(session)
    assert_equal(Map::START, room)

    room = room.go('tell a joke')
    assert_equal(Map::LASER_WEAPON_ARMORY, room)

    Map::save_room(session, room)
    assert_equal(Map::LASER_WEAPON_ARMORY, room)
  end
end
