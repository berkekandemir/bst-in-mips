.data
# the list to create the tree
list: .word 8, 3, 6, 10, 13, 7, 4, 5, -9999
# the value to be inserted to tree
list1: .word 14, -9999
# memory space for tree
tree: .space 4
# -9999 marks the end of the list
end: .word -9999
# Console outputs to track
root_is: .asciiz "Root is "
looked_left: .asciiz "Looked left\n"
looked_right: .asciiz "Looked right\n"
found_number: .asciiz "Found!\n"
not_found_number: .asciiz "Not found!\n"
insert_tree: .asciiz "\nInsert Tree:\n\n"
build_tree: .asciiz "Build Tree:\n\n"
# User input
enter_number: .asciiz "\nEnter a number to search: "
# Console outputs to track
added_left: .asciiz " added to left of "
added_right: .asciiz " added to right of "
# new line character
new_line: .asciiz "\n"
# console output for print function
print_tree: .asciiz "\nResult Tree:\n\n"
# between children print "-" if same parent
dash: .asciiz "-"
# if there is no child print "x"
x: .asciiz "x"
# between children print "    " if same parent
tab: .asciiz "    "

.text
.globl main

main:

    la    $a0, build_tree               # $a0 = build_tree address
    li    $v0, 4                        # $v0 = 4, print string
    syscall
    la    $a0, list                     # $a0 = list address to build the tree
    la    $a1, tree                     # $a1 = tree address
    la    $s7, end                      # $s7 = end of list
    jal   build                         # jump and link build


    la    $a0, insert_tree              # $a0 = insert_tree address
    li    $v0, 4                        # $v0 = 4, print string
    syscall
    la    $a0, list1                    # $a0 = value address to be inserted
    la    $a1, tree                     # $a1 = tree address
    move  $t8, $a0                      # store first $a0 to $t8
    move  $t9, $a1                      # store first $a1 to $t9
    jal   insert                        # jump and link insert

    la    $a0, enter_number             # $a0 = enter_number address
    li    $v0, 4                        # $v0 = 4, print string
    syscall
    li    $v0, 5                        # $v0 = 5, take input int
    syscall
    move  $a0, $v0                      # $a0 = user input
    la    $a1, tree                     # $a1 = tree address
    jal   find                          # jump and link find

    la    $a0, tree                     # $a0 = tree address
    jal   print                         # jump and link print

    j     exit                          # jump exit

exit:   

    li    $v0, 10                       # $v0 = 10, exit
    syscall

########################## START BUILD ##########################

build:                                  # build(list, tree)

    move  $s2, $a0                      # store first $a0 from $s2
    move  $s3, $a1                      # store first $a0 from $s3

    move  $t0, $a0                      # list = $t0
    lw    $t2, 0($t0)                   # $t2 = list[0]
    move  $t1, $a1                      # $t1 = tree
    move  $s6, $ra                      # store $ra     

    li    $a0, 16                       # $a0 = 16 byte space
    li    $v0, 9                        # $v0 = 9, sbrk
    syscall

    move  $s0, $v0                      # $s0 = $v0 Address of the root
    sw    $t2, 0($s0)                   # $s0 = list[0]
    sw    $zero, 4($s0)                 # left child = 0
    sw    $zero, 8($s0)                 # right child = 0
    sw    $zero, 12($s0)                # parent child = 0

    la    $a0, root_is                  # $a0 = root_is address
    li    $v0, 4                        # $v0 = 4, print_string
    syscall
    move  $a0, $t2                      # $a0 = value
    li    $v0, 1                        # $v0 = 1, print int
    syscall
    la    $a0, new_line                 # $a0 = new_line address
    li    $v0, 4                        # $v0 = 4, print_string
    syscall

    sw    $s0, 0($a1)                   # tree = $s0

    addi  $t0, $t0, 4                   # $t0 points the second element of the list, i++
    lw    $t2, 0($t0)                   # $t2 = list[i++]
    move  $a0, $t2                      # $a0 = value
    la    $a1, tree                     # $a1 = root of tree

    move  $t8, $a0                      # store first $a0 to $t8
    move  $t9, $a1                      # store first $a1 to $t9

    jal   insert                        # jump and link insert

    move  $a0, $s2                      # restore first $a0 from $s2
    move  $a1, $s3                      # restore first $a1 from $s3

    move  $ra, $s6                      # restore $ra
    jr    $ra

########################## END BUILD ##########################

########################## START INSERT ##########################

insert:                                 # insert(value, tree)

    beq   $t2, $t7, return              # if node value == -9999, return

    li    $a0, 16                       # $a0 = 16 byte space
    li    $v0, 9                        # $v0 = 9, sbrk
    syscall

    move  $s0, $v0                      # $s0 = $v0 Address of the node
    sw    $t2, 0($s0)                   # $s0 = list[0]
    sw    $zero, 4($s0)                 # left child = 0
    sw    $zero, 8($s0)                 # right child = 0
    sw    $zero, 12($s0)                # parent child = 0
    
    lw    $t3, 0($a1)                   # $t3 = root address
    lw    $t3, 0($t3)                   # take the value of the root
    slt   $t4, $t2, $t3                 # $t4 = 1 if $t2 < $t3
    
    lw    $t3, 0($a1)                   # take the memory of the root back
    bne   $zero, $t4, insert_left       # if smaller, insert_left
    beq   $zero, $t4, insert_right      # if larger or equal, insert_right

return:   

    add   $t0, $t0, 4                   # list index ++
    lw    $t2, 0($t0)                   # $t2 = list[i++]
    move  $a0, $t2                      # $a0, value
    lw    $t7, 0($s7)                   # copy -9999 to $t7
    bne   $a0, $t7, insert              # if value != -9999, continue loop

    move  $a0, $t8                      # restore first $a0 from $t8
    move  $a1, $t9                      # restore first $a1 from $t9

    jr    $ra                           # jump back
    
insert_left:

    lw    $t4, 4($t3)                   # take the address of left child
    beq   $zero, $t4, set_left          # if address == empty, set_left
    move  $t3, $t4                      # make child the current node
    lw    $t6, 0($t4)                   # take the value of the child

    slt   $t5, $t2, $t6                 # $t4 = 1 if $t2 < $t6
    bne   $zero, $t5, insert_left       # if smaller, insert_left
    beq   $zero, $t5, insert_right      # if larger or equal, insert_right

insert_right:

    lw    $t4, 8($t3)                   # take the address of right child
    beq   $zero, $t4, set_right         # if address == empty, set_right
    move  $t3, $t4                      # make child the current node                
    lw    $t6, 0($t4)                   # take the value of the child

    slt   $t5, $t2, $t6                 # $t4 = 1 if $t2 < $t6 
    bne   $zero, $t5, insert_left       # if smaller, insert_left
    beq   $zero, $t5, insert_right      # if larger or equal, insert_right

set_left:
    
    sw    $s0, 4($t3)                   # set left of parent
    sw    $t3, 12($s0)                  # set parent of left

    lw    $a0, 0($s0)                   # # $a0 = value of the child
    li    $v0, 1                        # $v0 = 1, print int
    syscall
    la    $a0, added_left               # $a0 = added_left address
    li    $v0, 4                        # $v0 = 4, print string
    syscall
    lw    $a0, 0($t3)                   # $a0 = value of the parent
    li    $v0, 1                        # $v0 = 1, print int
    syscall
    la    $a0, new_line                 # $a0 = new_line address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    move  $v0, $t3                      # copy inserted address to $v0
    j     return                        # jump return

set_right:

    sw    $s0, 8($t3)                   # set right of parent
    sw    $t3, 12($s0)                  # set parent of right

    lw    $a0, 0($s0)                   # # $a0 = value of child
    li    $v0, 1                        # $v0 = 1, print int
    syscall
    la    $a0, added_right              # $a0 = added_right address
    li    $v0, 4                        # $v0 = 4, print string
    syscall
    lw    $a0, 0($t3)                   # $a0 = value of parent
    li    $v0, 1                        # $v0 = 1, print int
    syscall
    la    $a0, new_line                 # $a0 = new_line address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    move  $v0, $t3                      # copy inserted address to $v0
    j     return                        # jump return

########################## END INSERT ##########################

########################## START FIND ##########################

find:                                   # find(value, tree)

    move  $s2, $a0                      # store first $a0 from $s2
    move  $s3, $a1                      # store first $a0 from $s3

    lw    $t0, 0($a1)                   # $t0 = root address

find_loop:

    beq   $t0, $zero, not_found         # if the current == $zero, not_found
    lw    $t2, 0($t0)                   # take the value of the current
    
    beq   $t2, $s2, found               # if desired == current, found
    slt   $t1, $s2, $t2                 # $t1 = 1 if $s2 < $t2
    bne   $zero, $t1, look_left         # if smaller, look_left
    beq   $zero, $t1, look_right        # if larger, look_right

look_left:

    la    $a0, looked_left              # $a0 = looked_left address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    add   $t0, $t0, 4                   # take left child
    lw    $t0, 0($t0)                   # take the left child's value
    j     find_loop                     # loop again

look_right:

    la    $a0, looked_right             # $a0 = looked_right address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    add   $t0, $t0, 8                   # take right child
    lw    $t0, 0($t0)                   # take the right child's value
    j     find_loop                     # loop again

found:

    la    $a0, found_number             # $a0 = found_number address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    move  $a0, $s2                      # restore first $a0 from $s2
    move  $a1, $s3                      # restore first $a1 from $s3
    li    $v0, 0                        # put 0 to $v0
    jr    $ra                           # return to main

not_found:

    la    $a0, not_found_number         # $a0 = not_found_number address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    move  $a0, $s2                      # restore first $a0 from $s2
    move  $a1, $s3                      # restore first $a1 from $s3
    li    $v0, 1                        # put 1 to $v0
    jr    $ra                           # return to main


########################## END FIND ##########################

########################## START PRINT ##########################

print:                                  # print(tree)

    move  $s0, $a0                      # store first $a0 to $s0
    move  $t0, $a0                      # copy address of tree

    la    $a0, print_tree               # a0 = print_tree address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    move  $t9, $ra                      # store $ra to $t9
    li    $t8, 1                        # level = 1
    li    $t7, 5                        # height = 5
    li    $t6, 1                        # condition

    lw    $t0, 0($t0)                   # address of the root
    move  $s1, $t0                      # store the address of the root

    move  $a0, $s1                      # $a0 = $s1

print_level_order:

    add   $t8, $t8, 1                   # level++
    jal   print_level                   # jump and link print_level

    la    $a0, new_line                 # $a0 = new_line address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    bne   $t8, $t7, print_level_order   # if level != height, loop    

    move  $a0, $s0                      # restore first $a0 from $s0
    move  $ra, $t9                      # restore $ra from $t9
    jr    $ra                           # jump back to main

print_level: 
    
    bne   $t8, $t6, print_value         # if level == 1, print_value

    add   $t8, $t8, -1                  # level--
    lw    $t0, 4($a0)                   # address of the left child
    jal   print_level                   # loop recursively wth left child

    la    $a0, dash                     # $a0 = dash address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    lw    $t0, 8($a0)                   # address of the left childben
    jal   print_level                   # loop recursively with right child

    la    $a0, tab                      # $a0 = tab address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    jr    $ra                           # return print_level_order link

print_value:

    beq   $t0, $zero, print_empty       # if the child is empty, print_empty
    lw    $t0, 0($t0)                   # take the value of child
    move  $a0, $t0                      # $a0 = value
    li    $v0, 1                        # $v0 = 1, print int
    syscall

    jr    $ra                           # jump back to print_level_order link

print_empty:

    la    $a0, x                        # $a0 = x address
    li    $v0, 4                        # $v0 = 4, print string
    syscall

    jr    $ra                           # jump back to print_level_order link

########################## END PRINT ##########################