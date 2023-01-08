# frozen_string_literal: true

class Node
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end

# function to convert sorted array to a
# balanced BST
# input : sorted array of integers
# output: root node of balanced BST
class Tree
  attr_accessor :root, :arr

  def initialize(arr)
    @root = build_tree(arr)
    @arr = arr
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

  def insert(leaf, node = root)
    # check for duplicate values
    return if @arr.include?(leaf)

    if leaf < node.data
      node.left = Node.new(leaf) if node.left.nil?
      node.left = insert(leaf, node.left)
      # go right
    elsif leaf > node.data
      node.right = Node.new(leaf) if node.right.nil?
      node.right = insert(leaf, node.right)
    end
    node
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
      tree = nil

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

    result << node
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

  def height(input, node = root)
    input = input.data if input.instance_of?(Node)

    if input < node.data
      height(input, node.left)
    elsif input > node.data
      height(input, node.right)
    elsif input == node.data
      leaf_node?(node)
    end
  end

  def leaf_node?(node, counter = [0])
    return 0 if node.nil?

    if !node.left.nil?
      counter << counter [-1] + 1
      leaf_node?(node.left, counter)
    elsif !node.right.nil?
      counter << counter [-1] + 1
      leaf_node?(node.right, counter)
    elsif node.left.nil? && node.right.nil?
      counter[-1]
    end
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

  def balanced?(result: true)
    node_array = preorder
    node_array.each do |node|
      next if node.left.nil? || node.right.nil?

      left = height(node.left)
      right = height(node.right)
      result = false unless (left - right).between?(-1, 1)
    end
    result
  end

  def rebalance
    node_array = inorder

    # workaround to include also the last value of arr in the tree
    node_array << node_array.max + 1
    build_tree(node_array)
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
