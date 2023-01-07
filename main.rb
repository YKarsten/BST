# frozen_string_literal: true

require_relative 'lib/node'
# require_relative 'lib/tree'

# function to convert sorted array to a
# balanced BST
# input : sorted array of integers
# output: root node of balanced BST
class Tree
  attr_accessor :root

  def initialize(arr)
    @root = build_tree(arr)
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

  def level_order
    # if the tree is empty, return
    return if root.nil?

    queue = [root]
    result = []

    # While there is at least one discovered node
    until queue.empty?
      # push the address of the nodes children to the queue

      queue << queue[0].left unless queue[0].left.nil?
      queue << queue[0].right unless queue[0].right.nil?

      # print the data from that node
      result << queue[0].data

      # remove the front element of the queue
      queue.shift
    end
    if block_given?
      result.each { |node| yield node}
    else
      # print just the end result
      result
    end
  end

  def preorder(node = root, result = [], &block)
    if node.nil? && block_given?
      # the block gets lost during the recursion?
      result.each { |node| yield node}
    elsif node.nil?
      return result
    end

    result << node.data
    preorder(node.left, result)
    preorder(node.right, result)
  end

  def inorder(node = @root, result = [], &block)
    return result if node.nil?

    inorder(node.left, result)
    result << node.data
    inorder(node.right, result)
  end

  def postorder(node = @root, result = [], &block)
    return result if node.nil?

    postorder(node.left, result)
    postorder(node.right, result)
    result << node.data
  end

  def height(input, node = root, counter = [0])
    if input < node.data
      counter << counter[-1] + 1
      height(input, node.left, counter)
    elsif input > node.data
      counter << counter[-1] + 1
      height(input, node.right, counter)
    end

    counter[-1] - leaf_node?(node)
  end

  def depth(input, node = root, depth = [0])
    if input < node.data
      depth << depth[-1] + 1
      depth(input, node.left, depth)
    elsif input > node.data
      depth << depth[-1] + 1
      depth(input, node.right, depth)
    end
    depth[-1]
  end

  def leaf_node?(node, counter = [0])
    if !node.left.nil?
      counter << counter [0] + 1
      leaf_node?(node.left, counter)
    elsif !node.right.nil?
      counter << counter [0] + 1
      leaf_node?(node.right, counter)
    elsif node.left.nil? && node.right.nil?
      counter[-1]
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

puts 'tree: '
pretty_print(tree.root)

puts 'inserted tree'
pretty_print(tree.insert(tree.root, 2))

puts 'deleted leaf node 7'
pretty_print(tree.delete(tree.root, 7))

puts 'deleted node with child 3'
pretty_print(tree.delete(tree.root, 3))

puts 'find me node 67'
tree.find(tree.root, 67)

puts 'Level order traversal'
tree.level_order do |node|
  puts "level order #{node}"
end

puts 'preorder'
p tree.preorder

puts 'preorder block test'
tree.preorder { |lang| puts "preorder #{lang}" }

puts 'inorder'
p tree.inorder

puts 'postorder'
p tree.postorder

puts 'height of node 324'
p tree.height(324)

puts 'depth of node 324'
p tree.depth(324)
