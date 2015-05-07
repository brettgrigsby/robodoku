class Section
  attr_reader :spots

  def initialize(spots)
    @spots = spots
  end

  def set_peers
    @spots.each { |spot| spot.peers += (@spots - [spot]) }
  end

  def siblings(spot)
    unsolved_spots - [spot]
  end

  def solved_spots
    spots.reject(&:unsolved?)
  end

  def unsolved_spots
    spots.select(&:unsolved?)
  end

  def solved_values
    solved_spots.map(&:value).flatten.uniq
  end

  def unsolved_values
    unsolved_spots.map(&:candidates).flatten.uniq
  end

  def sibling_candidates(spot)
    (unsolved_spots - [spot]).map(&:candidates).flatten.uniq
  end

  def find_hidden_single
    spots.each do |spot|
      possibles = spot.candidates - (sibling_candidates(spot) + solved_values).uniq
      possibles.size == 1 ? spot.value = possibles[0] : nil
    end
  end

  def find_naked_pair
    naked_hash = spots.group_by(&:candidates)
    naked_pair = naked_hash.select { |candidates, spots| candidates.size == 2 && spots.size == 2 }
    if naked_pair.empty?
      nil
    else
      (unsolved_spots - naked_pair.flatten[1]).each do |spot|
        spot.remove_candidates(naked_pair.flatten[0])
      end
    end
  end

  def find_hidden_pair
    unsolved_spots.each do |spot|
      sibs = siblings(spot)
      sibs.each do |sib|
        candidates = (sibs - [sib]).map(&:candidates).flatten.uniq
        potential_hp = sib.candidates - candidates
        if (spot.candidates - candidates) == potential_hp && potential_hp.size == 2
          sib.candidates -= candidates
          spot.candidates -= candidates
        end
      end
    end
  end

end

class Row < Section
  def output
    spots.map(&:value).join
  end
end

class Column < Section
end

class Square < Section
end
