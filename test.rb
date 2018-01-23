require 'minitest/autorun'
require "./REPL.rb"

class REPLTest < Minitest::Test

  #test if help works
  def test_help
    repl = REPL.new
    out, _ = capture_io do
      repl.process "help"
    end
    expected = open('user_manual').read + "\n"
    assert_match out, expected
  end

  #test what happen when user enters an undefined command 
  def test_wrong_inp
    repl = REPL.new
    out, _ = capture_io do
      repl.process "ls"
    end
    expected = "command 'ls' cannot be understood.\n"
    assert_match out, expected
  end

  #test add new artist or track
  def test_add_new_artist_and_track
    repl = REPL.new
    repl.clear
    repl.process "add artist Imagine Dragon"
    repl.process "add tracks Whatever it takes by ID"
    out, _ = capture_io do
      repl.process "info"
    end
    expected = "/There\ are\ 1\ tracks,\ \nID:0,\ Whatever\ it\ takes\ \ by\ Imagine\ Dragon\ \nNever\ played\ any\ tracks\.\n/"
    assert_match out, expected
  end

  #add some artist and tracks
  #test if output is correct when enter 
  def test_play
    repl = REPL.new
    repl.clear
    repl.process "add artist Imagine Dragon"
    repl.process "add tracks Whatever it takes by ID"
    repl.process "add artist Drake"
    repl.process "add tracks More Life by D"
    repl.process "play track 1"
    repl.process "play track 0"
    repl.process "play track 1"
    
    out, _ = capture_io do
      repl.process "info"
    end
    assert_match out, "/There\ are\ 2\ tracks,\ \nID:0,\ Whatever\ it\ takes\ \ by\ Imagine\ Dragon\ \nID:1,\ More\ Life\ \ by\ Drake\ \nRecently\ played:\n1:\ ID:\ 1,\ Name:\ More\ Life\ \n2:\ ID:\ 0,\ Name:\ Whatever\ it\ takes\ \n3:\ ID:\ 1,\ Name:\ More\ Life\ \n/"
  end

end
