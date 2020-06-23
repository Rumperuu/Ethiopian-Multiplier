################################################################################
#                           Ethiopian Multiplier 1.0                           #
#                   Copyright © 2014 Ben Goldsworthy (rumps)                   #
#                                                                              #
# A program to perform Ethiopian mulitplication on two positive values.        #
#                                                                              #
# This program is free software: you can redistribute it and/or modify         #
# it under the terms of the GNU General Public License as published by         #
# the Free Software Foundation, either version 3 of the License, or            #
# (at your option) any later version.                                          #
#                                                                              #
# This program is distributed in the hope that it will be useful,              #
# but WITHOUT ANY WARRANTY; without even the implied warranty of               #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                #
# GNU General Public License for more details.                                 #
#                                                                              #
# You should have received a copy of the GNU General Public License            #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.        #
################################################################################

Main:
   lui $s0, 0x1001			    # sets $s0 to pointer at start of data segment
   lw $a0, 0($s0)				# sets $a0 to 0x10010000
   lw $a1, 4($s0)				# sets $a1 to 0x10010004
   bne $a0, 0, Continue		    # Skips to the multiplication if a != 0
   sw 0, 8($s0)                 # stores 0 at 0x10010008
   j Result                     # jumps to the result
Continue:
   jal Ethiopian				# jumps to do the Ethiopian multiplication if not
   sw 0, 8($s0)                 # stores the result at 0x1001008
   j Result                     # jumps to the result
Result:
   lw $a0, 8($s0)				# loads the result
   addi $v0, $zero, 1		    # sets SYSCALL to print an int
   syscall						# invokes syscall
   j Exit						# exits

Ethiopian:
  	Loop:
   	srl $a0, $a0, 1		        # halves a
   	sll $a1, $a1, 1		        # doubles b
    	and $t0, $a0, 1		    # checks if a is odd
    	beq $t0, 1, Multiply	# goes to Multiply if it is
    	bne $a0, 1, Loop 		# loops if a != 1...
    	jr $ra					# ...else, returns to the program
  	Multiply:
    	add $v0, $v0, $a1		# adds b to the result
    	bne $a0, 1, Loop 		# loops if a != 1...
    	jr $ra					# ...else, returns to the program
		
Exit:
  	addi $v0, $zero, 10		    # sets SYSCALL to exit
	syscall						# invokes syscall
