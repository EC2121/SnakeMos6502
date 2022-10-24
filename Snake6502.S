.org $8000
.define direction $03FF
.define snakeLength $03FE 
.define accumulator $03FD
.define snakeHead $00 
.define apple $03FD ; apple pos
;Values of directions
.define up #1
.define down #2
.define left #3
.define right #4


start:
JMP init

gameLoop:
JSR input
JSR headUpdate
JSR bodyUpdate
JSR draw
JSR checkCollision
JSR increseAccumulator
JMP gameLoop


increseAccumulator:
LDA accumulator
ADC #1
STA accumulator

End:
Jmp End

checkCollision:
LDA snakeHead
CMP apple
BEQ collide
RTS


init:
LDX #$FF
TXS
LDX #0
LDA #4
STA snakeLength ; real value is decremented by 1, in this case it will be 3
LDA #2
STA direction
LDA #158
STA apple
LDX apple
LDA #4
STA $0200,X
JMP gameLoop





collide:
JSR drawNewPiece

LDX snakeLength
INX 
STX snakeLength

; Pseudo Random
LDA apple
ADC accumulator
STA apple
RTS


drawNewPiece:
LDY snakeLength
DEY
LDX snakeHead,Y
LDA #1
STA $0200,X
RTS


draw:
; Draw apple
LDX apple
LDA #4
STA $0200,X
;Cancel last piece
LDX snakeLength
DEX
LDY snakeHead,X
LDA #0
STA $0200,Y
; Draw head
LDX snakeHead
LDA #1
STA $0200,X
RTS


bodyUpdate:
LDX #0
innerLoop:

INX
TYA ; in the first cicle Y has the OLD value of snakeHead, see HeadUpdate
LDY snakeHead,X
STA snakeHead,X
LDA snakeHead

;Check Collision with body
CMP snakeHead,X
BEQ gameOver

TXA 
CMP snakeLength ;Check if all pieces have been updated
BNE innerLoop ; if not loop again
RTS


gameOver:
JMP End

headUpdate:
LDA direction
CMP up
BEQ goUp

CMP down
BEQ goDwn

CMP left
BEQ goLft

CMP right
BEQ goRth
RTS

goRth:
LDA snakeHead
LDY snakeHead
CLC
ADC #1
STA snakeHead
RTS

goLft:
LDA snakeHead
LDY snakeHead
SBC #1
STA snakeHead
RTS

goDwn:
LDA snakeHead
LDY snakeHead
CLC
ADC #16
STA snakeHead
RTS

goUp:
LDA snakeHead
LDY snakeHead
CLC
SBC #15
STA snakeHead
RTS

input:
LDA $4000
CMP #1
BEQ moveUp
CMP #2
BEQ moveDown
CMP #4
BEQ moveLeft
CMP #8
BEQ moveRight
RTS

moveUp:
LDA direction
CMP down ;check illegal moves
BNE dirUp
RTS

moveDown:
LDA direction
CMP up ;check illegal moves
BNE dirDown
RTS

moveLeft:
LDA direction
CMP right ;check illegal moves
BNE dirLeft
RTS

moveRight:
LDA direction
CMP left ;check illegal moves
BNE dirRight
RTS

dirRight:
LDA right
STA direction
RTS

dirLeft:
LDA left
STA direction
RTS

dirDown:
LDA down
STA direction
RTS

dirUp:
LDA up
STA direction
RTS

.goto $FFFA
.dw start
.dw start
.dw start