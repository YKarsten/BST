# frozen_string_literal: true

require_relative 'lib/node'
# require_relative 'lib/tree'

# function to convert sorted array to a
# balanced BST
# input : sorted array of integers
# output: root node of balanced BST
class Tree
  attr_accessor :root

  def initialize(array)
    @root = array
  end

  def build_tree(arr)
    # guard clause
    return nil if arr.is_a?(Array) == false
    return if arr.size == 1

    # sort and remove duplicates
    arr = arr.uniq.sort

    # find middle index
    mid = (arr.size / 2) - 1

    # make the middle element the root
    node = Node.new(arr[mid])

    # left subtree of root has all
    # values <arr[mid]
    node.left = build_tree(arr[0..mid])

    # right subtree of root has all
    # values >arr[mid]
    node.right = build_tree(arr[mid + 1..])

    # return
    node
  end

  def insert(tree, leaf)
    if leaf < tree.data
      if tree.left == nil
        tree.left = Node.new(leaf)
      else
        insert(tree.left, leaf)
      end
    elsif tree.right == nil
      tree.right = Node.new(leaf)
    else
      insert(tree.right, leaf)
    end
    tree
  end
end

def pretty_print(node = @root, prefix = '', is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
  puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
  pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
# workaround to include also the last value of arr in the tree
# This doesnt work when inserting a higher than previous max value
arr << arr.max + 1

tree = Tree.new(arr)
node_tree = tree.build_tree(arr)

puts 'tree: '
pretty_print(node_tree)


puts 'inserted tree'
inserted = tree.insert(node_tree, 2)
pretty_print(inserted)
