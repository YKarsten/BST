# frozen_string_literal: true

# This class represents a node in a balanced binary search tree (BST)
class Node
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end
