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

  def delete(tree, node)
    # go left
    if node < tree.data
      tree.left = delete(tree.left, node)
      # go right
    elsif node > tree.data
      tree.right = delete(tree.right, node)
      # its a leaf node, delete that node
    elsif tree.left.nil? && tree.right.nil?
      tree.data = nil
      # its a node with a single child, make the node's parent point to node's child
    elsif single_child(tree, node)
      tree = if child_side(tree, node) == 'right'
               tree.right
             else
               tree.left
             end
    end
    tree
  end

  def find(tree, node)
    if node < tree.data
      find(tree.left, node)
    elsif node > tree.data
      find(tree.right, node)
    elsif node == tree.data
      puts tree
    else
      puts 'no such entry'
    end
  end

  def leaf_node?(tree, node)
    if node < tree.data
      leaf_node?(tree.left, node)
    elsif node > tree.data
      leaf_node?(tree.right, node)
    elsif tree.left.nil? && tree.right.nil?
      true
    else
      false
    end
  end

  def single_child(tree, node)
    if node < tree.data
      single_child(tree.left, node)
    elsif node > tree.data
      single_child(tree.right, node)
    elsif !tree.left.nil? && !tree.right.nil?
      false
    elsif tree.left.nil? && tree.right.nil?
      false
    else
      true
    end
  end

  def child_side(tree, node)
    if node < tree.data
      child_side(tree.left, node)
    elsif node > tree.data
      child_side(tree.right, node)
    elsif tree.left.nil? && !tree.right.nil?
      'right'
    elsif !tree.left.nil? && tree.right.nil?
      'left'
    else
      false
    end
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
pretty_print(tree.insert(node_tree, 2))

puts 'deleted leaf node 7'
pretty_print(tree.delete(node_tree, 7))

puts 'deleted node with child 3'
pretty_print(tree.delete(node_tree, 3))

puts 'find me node 67'
tree.find(node_tree, 67)
