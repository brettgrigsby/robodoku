class Spot
  attr_accessor :value, :peers, :candidates

  def initialize(value)
    @value = value
    @peers = []
    @candidates = ['1','2','3','4','5','6','7','8','9']
  end

  def peer_values
    @peers.map(&:value).uniq
  end

  def remove_candidates(candidates)
    @candidates -= candidates
  end

  def remove_peer_candidates
    @candidates -= peer_values
  end

  def inspect
    "Spot - Value:#{@value}, Peers:#{@peers.size}, Candidates:#{@candidates.join(',')}"
  end

  def unsolved?
    value == ' '
  end

  def simple_solve
    @candidates.size == 1 ? @value = @candidates[0] : nil
  end

  def incorrect?
    @candidates == [] && @value == ' '
  end

end
