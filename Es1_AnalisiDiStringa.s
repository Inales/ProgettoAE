#Title: Analisi di stringhe

#Author: Andrea Chimenti (andrea.chimenti@stud.unifi.it) 5945877 - Denny Verduchi (denny.verduchi@stud.unifi.it) 5898088
 
#Description: il programma legge inizialmente una stringa e la traduce nei modi richiesti

#Input: il programma chiede in ingresso una stringa di massimo 100 caratteri

#Output: il programma restituisce il risultato dell'applicazione della traduzine richiesta

#Filename: Es1_AnalisiDiStringa.s

#Date: 25-05-2017
.data
prompt:      .asciiz "\nInserisci una stringa di dimensioni massima 100 caratteri: \n " 
buffer:        .space  101
one:          .asciiz "1 "
two:          .asciiz "2 "
nine:        .asciiz "9 "
another:   .asciiz "? "

.text
.globl main 

main:
        li $v0, 4                   #codice di stampa stringa = 4 
        la $a0, prompt    #carica la stringa contenuta in prompt
        syscall                      #stampa la stringa sul terminale
       
       la $a0,  buffer    #carica il buffer in $a0
       li $a1, 101          #carica la lunghezza del buffer in $a1
       li $v0, 8                #codice di lettura stringa = 8
       syscall 
       
       move $s0, $a0  #sposta il valore di $a0 in $s0
       move $s1, $a0 #sposta il valore di $a0 in $s1
       li $t0, 0                #inizialize a 0 $t0 che verrà usato per contare la lunghezza delle sottostringhe
       li $t2, 107          #inizializzo $t2 così da essere sicuro del suo valore
       
       
controlSpace:

        lb $s3, 0($s1)          #carica in $s3 il byte contenuto in $s1
        li $t1, ' '                     # carica il carattere ' ' in $t1 per il confronto    
        bne $s3, $t1, scan     #se $s3 è uguale a ' ' salta a scan
        addi $s1, $s1, 1        #avanza di un 1 il registro $s1 usato come puntatore sulla stringa
        move $s0, $s1           #sposta il valore di $s1 in $s0
        j controlSpace        #salto incondizionato all'etichetta controlSpace
       
scan:
        lb $s2,0($s1)           #carica in $s2 il byte contenuto in $s1
        beq $s2, $zero, ultimateControl     #se $s2 è uguale a 0 (carattere di fine stringa) salta a ultimateControl
        li $t1, ' '         # carica il carattere ' ' in $t1 per il confronto   
        beq $s2, $t1, controlLength                #se  $s2 è uguale a ' ' salta a controlLength
        addi $t0, $t0, 1        #aumenta il contatore $t0 di uno
        addi $s1, $s1, 1        #avanza il puntatore $s1 di un byte
        j scan     #salto incondizionato all'etichetta scan
        
inizialize:

        move $s0, $s1              #sposta il valore di $s1 in $s0
        li $t0, 0                       #rinizializza a 0 $t0
        j controlSpace        #salto incondizionato all'etichetta controlSpace

controlLength:
        
         li $t1, 3          # carica il carattere 3 in $t1 per il confronto   
        beq $t0, $t1, controlOne  #se $t0 è uguale a 3 salta a controlOne
        li $t1, 4           # carica il carattere 4 in $t1 per il confronto   
        beq $t0, $t1, controlNine  #se $t0 è uguale a 4 salta a controlNine
        j printAnother  #salto incondizionato a printAnother

controlOne:

        lb $s2, 0($s0)  #carica in $s2 il byte all'indirizzo $s0
        li $t1, 'u'          # carica il carattere u in $t1 per il confronto   
        bne $s2, $t1, controlTwo #se $s2 non è u salta a controlTwo
        lb $s2, 1($s0)  #carica in $s2 il secondo byte dell'indirizzo $s0
         li $t1, 'n'        # carica il carattere n in $t1 per il confronto  
        bne $s2, $t1, printAnother #se $s2 non è u salta a printAnother
        lb $s2, 2($s0)  #carica in $s2 il terzo byte dell'indirizzo $s0
        li $t1, 'o'        # carica il carattere o in $t1 per il confronto  
        bne $s2, $t1, printAnother   #se $s2 non è o salta a printAnother
        j printOne #salto incondizionato a printOne

controlTwo:

         li $t1, 'd'         # carica il carattere d in $t1 per il confronto 
        bne $s2, $t1, printAnother  #se $s2 non è d salta a printAnother
        lb $s2, 1($s0)  #carica in $s2 il secondo byte dell'indirizzo $s0
        li $t1, 'u'             # carica il carattere u in $t1 per il confronto 
        bne $s2, $t1, printAnother   #se $s2 non è u salta a printAnother
        lb $s2, 2($s0)   #carica in $s2 il terzo byte dell'indirizzo $s0
         li $t1, 'e'           # carica il carattere e in $t1 per il confronto 
        bne $s2, $t1, printAnother  #se $s2 non è e salta a printAnother
        j printTwo  #salto incondizionato a printTwo

controlNine: 

        lb $s2, 0($s0) #carica in $s2 il  byte all'indirizzo $s0
         li $t1, 'n'     # carica il carattere n in $t1 per il confronto 
        bne $s2, $t1, printAnother   #se $s2 non è n salta a printAnother
        lb $s2, 1($s0)      #carica in $s2 il secondo byte dell'indirizzo $s0
        li $t1, 'o'      # carica il carattere o in $t1 per il confronto 
        bne $s2, $t1, printAnother   #se $s2 non è o salta a printAnother
        lb $s2, 2($s0)    #carica in $s2 il terzo byte dell'indirizzo $s0
        li $t1, 'v'      # carica il carattere v in $t1 per il confronto 
        bne $s2, $t1, printAnother   #se $s2 non è v salta a printAnother
        lb $s2, 3($s0)      #carica in $s2 il quarto byte dell'indirizzo $s0
         li $t1, 'e'     # carica il carattere e in $t1 per il confronto 
        bne $s2, $t1, printAnother   #se $s2 non è e salta a printAnother
        j printeNine        #salto incondizionato a printeNine
       
printOne:

        la $a0, one     #carica la stringa contenuta in one
        li $v0, 4               #codice di stampa stringa = 4 
        syscall                  #stampa la stringa sul terminale
        
        beq $t2, 0, exit      #se $t2 è uguale a 0 (carattere fine stringa) salta a exit     
        j inizialize  #salto incondizionato all'etichetta inizialize
        
printTwo:

        la $a0, two   #carica la stringa contenuta in two
        li $v0, 4       #codice di stampa stringa = 4 
        syscall          #stampa la stringa sul terminale
        
        beq $t2, 0, exit        #se $t2 è uguale a 0 (carattere fine stringa) salta a exit
        j inizialize        #salto incondizionato all'etichetta inizialize
        
printeNine:

        la $a0, nine       #carica la stringa contenuta in nine
        li $v0, 4       #codice di stampa stringa = 4 
        syscall          #stampa la stringa sul terminale
        
        beq $t2, 0, exit      #se $t2 è uguale a 0 (carattere fine stringa) salta a exit
        j inizialize        #salto incondizionato all'etichetta inizialize
        
printAnother:

        la $a0, another #carica la stringa contenuta in another
        li $v0, 4       #codice di stampa stringa = 4 
        syscall          #stampa la stringa sul terminale
        
        beq $t2, 0, exit      #se $t2 è uguale a 0 (carattere fine stringa) salta a exit
        j inizialize        #salto incondizionato all'etichetta inizialize
        
ultimateControl:

        move $t2, $s2       #sposta il valore di $s2 in $t2
        lb $s4, -1($s1)     #carica in $s4 il byte all'indirizzo precedente di $s1
        li $t1, ' '                     #carica ' ' in $t1 per il confronto
        beq $s4, $t1, exit
        li $t1, '\n'            #carica il carattere \n in $t1
        bne $s4, $t1, controlLength #se $s4 non è uguale a \n salta a controlLength
        addi $t0, $t0,  -1      #sottrae uno al contatore della lunghezza 
                                             #delle sottostringhe $t0, per non contare \n come carattere 
        li $t1, ' '                     #carica ' ' in $t1 per il confronto
         lb $s4, -2($s1)
         beq $s4, $t1, exit
         lb $s4, -1($s1) 
         bne $s4, $t1 , controlLength #se $s4 non è uguale a ' ' salta a controlLength
        
exit:
       
        li $v0,10  #codice di terminazione programma  = 10 
        syscall   #termina programma
