# frozen_string_literal: true

require_relative 'lib/tree'

def pretty_print(node = @root, prefix = '', is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
  puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
  pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
end

arr = (Array.new(15) { rand(1..100) })
# workaround to include also the last value of arr in the tree
arr << arr.max + 1

tree = Tree.new(arr)

puts 'Randomly generated binary search tree: '
pretty_print(tree.root)

puts 'Is the tree balanced?'
p tree.balanced?

puts 'Level order traversal'
p tree.level_order

# Needs node.data to print properly
puts 'Preorder traversal'
tree.preorder

puts 'Inorder traversal'
p tree.inorder

puts 'Postorder traversal'
p tree.postorder

puts 'Now we insert 100 nodes to imbalance the tree'
100.times { tree.insert(rand(1..100)) }
pretty_print(tree.root)

puts 'Is the tree balanced?'
p tree.balanced?

puts 'Lets rebalance the bigger tree'
tree.root = tree.rebalance
pretty_print(tree.rebalance)

puts 'Is the tree balanced?'
p tree.balanced?

puts 'Level order traversal'
p tree.level_order

# Needs node.data to print properly
puts 'Preorder traversal'
tree.preorder

puts 'Inorder traversal'
p tree.inorder

puts 'Postorder traversal'
p tree.postorder
