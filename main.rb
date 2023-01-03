# frozen_string_literal: true

require_relative 'lib/node'
require_relative 'lib/tree'

# function to convert sorted array to a
# balanced BST
# input : sorted array of integers
# output: root node of balanced BST
def build_tree(arr)
  # guard clause
  return nil if arr.is_a?(Array) == false
  return if arr.size == 1

  # find middle index
  mid = (arr.size / 2) - 1

  # make the middle element the root
  root = Node.new(arr[mid])

  # left subtree of root has all
  # values <arr[mid]
  root.left = build_tree(arr[0..mid])

  # right subtree of root has all
  # values >arr[mid]
  root.right = build_tree(arr[mid + 1..])

  # return
  root
end

def pretty_print(node = @root, prefix = '', is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
  puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
  pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
end

# driver program to test above function

# Constructed balanced BST is
#   4
# / \
# 2 6
# / \ / \
# 1 3 5 7

arr = [1, 2, 3, 4, 5, 6, 7, 8]
root = build_tree(arr)
pretty_print(root)

# test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
# build_tree(test_array)
