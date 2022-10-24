.org $8000
.define direction $03FF
.define snakeHead $00
.define snakeLength $03FE
.define apple $03FD



start:
JMP init

gameLoop:
JSR input
JSR headUpdate
LDX #1
JSR bodyUpdate
JSR draw
JSR checkCollision
JMP gameLoop


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
LDA #4
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
TXA
STA snakeLength
LDA apple
ADC snakeLength
ADC snakeHead
ADC direction
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
LDX apple
LDA #4
STA $0200,X
LDA snakeLength
TAX 
DEX
LDY snakeHead,X
LDA #0
STA $0200,Y
LDX snakeHead
LDA #1
STA $0200,X
RTS


bodyUpdate:
TYA
LDY snakeHead,X
STA snakeHead,X
LDA snakeHead
CMP snakeHead,X
BEQ gameOver

INX
TXA
CMP snakeLength
BNE bodyUpdate
RTS


gameOver:
JMP End

headUpdate:
LDA direction
CMP #1
BEQ goUp
CMP #2
BEQ goDwn
CMP #3
BEQ goLft
CMP #4
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
CMP #2
BNE dirUp
RTS

moveDown:
LDA direction
CMP #1
BNE dirDown
RTS

moveLeft:
LDA direction
CMP #4
BNE dirLeft
RTS

moveRight:
LDA dirDown
CMP #3
BNE dirRight
RTS

dirRight:
LDA #4
STA direction
RTS

dirLeft:
LDA #3
STA direction
RTS

dirDown:
LDA #2
STA direction
RTS

dirUp:
LDA #1
STA direction
RTS

.goto $FFFA
.dw start
.dw start
.dw start