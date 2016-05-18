#lang racket
(require "combat.rkt")
(require "characters.rkt")
(require "spells.rkt")
(require "items.rkt")
(require "dungeons.rkt")
(require "store.rkt")
(require "create.rkt")
(require "music.rkt")
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)
(provide (all-defined-out))

;; dungeon-name
;; room-name

;; player
#|
name
health
max-health
agility
strength

spells

inventory:
  weapon
  equiped
  equipment
  consumables
  gold*
  misc

position
lvl
mp
max-mp
current-xp
|#

;; get items : list-of-strings --> list of item%s
(define (get-items l)
  (cond
    [(empty? l) empty]
    [(cons? l)
     (cons (return-item (first l) ITEM-DIRECTORY)
           (get-items (rest l)))]))

;; return-item
(define (return-item s l)
  (cond
    [(string=? s (send (first l) get-name)) (first l)]
    [else (return-item s (rest l))]))

;; get-spells : los --> lospells
(define (get-spells l)
  (cond
    [(empty? l) empty]
    [(cons? l)
     (cons (return-spell (first l) SPELL-DIRECTORY)
           (get-spells (rest l)))]))

;; return-spell
(define (return-spell s l)
  (cond
    [(string=? s (spell-name (first l))) (first l)]
    [else (return-spell s (rest l))]))

;; save->dungeon
(define (save->dungeon s)
  (local [(define save (read-words/line s))
          (define (dechript s) (dechript-string s (first (first save))))
          (define (dechript-list l)
            (cond
              [(empty? l) empty]
              [(cons? l) (cons (dechript (first l))
                               (dechript-list (rest l)))]))]
    (derive-dungeon
     (dechript (second (first save)))
     (dechript (third (first save)))
     (dechript (fourth (first save)))
     (dechript (first (second save)))
     (dechript (second (second save)))
     (dechript (third (second save)))
     (dechript (fourth (second save)))
     (dechript-list (third save))
     (dechript (first (fourth save)))
     (dechript-list (fifth save))
     (list
      (dechript-list (sixth save))
      (dechript-list (seventh save))
      (dechript-list (eighth save))
      (dechript-list (ninth save))
      (dechript-list (tenth save)))
     (dechript-list (tenth (rest save)))
     (dechript (first (tenth (rest (rest save)))))
     (dechript-list (rest (tenth (rest (rest save)))))
     (dechript-list (tenth (rest (rest (rest save)))))
     (dechript (first (tenth (rest (rest (rest (rest save)))))))
     (dechript (second (tenth (rest (rest (rest (rest save)))))))
     (dechript (third (tenth (rest (rest (rest (rest save)))))))
     (dechript (fourth (tenth (rest (rest (rest (rest save)))))))
     (dechript (first (tenth (rest (rest (rest (rest (rest save)))))))))))


;; derive-dungeon
(define (derive-dungeon dn rn n h mh a s sp iw ie ieq ic g m p l mp mmp xp gen)
  (make-dungeon (derive-player n h mh a s sp iw ie ieq ic g m p l mp mmp xp gen)
                (cons (get-room (get-dungeon dn) rn)
                      (filter (lambda (x) (not (string=? (room-name x) rn)))
                              (dungeon-rooms (get-dungeon dn)))) empty dn empty))

;; derive-player : string string string string string los string los los
;; lolos los string los los string string string string --> player
(define (derive-player n h mh a s sp iw ie ieq ic g m p l mp mmp xp gen)
  (send SPELLSWORD clone
        #:name n #:health (string->number h) #:max-health (string->number mh)
        #:agility (string->number a) #:base-agility (string->number a)
        #:strength (string->number s) #:base-strength (string->number s)
        #:spells (get-spells sp)
        #:character-inventory (make-inventory (if (string=? iw "empty")
                                                  empty
                                                  (first (get-items (list iw))))
                                              (get-items ie)
                                              (list
                                               (get-items (first ieq))
                                               (get-items (second ieq))
                                               (get-items (third ieq))
                                               (get-items (fourth ieq))
                                               (get-items (fifth ieq)))
                                              (get-items ic)
                                              (cons
                                               (add-gold (string->number g))
                                               (get-items m)))
        #:animation (if (eq? gen "m")
                        (make-animation (flip-horizontal (bitmap/file "standby-m.png"))
                                        (flip-horizontal (bitmap/file "attack-m.png"))
                                        (flip-horizontal (bitmap/file "cast-m.png"))
                                        (flip-horizontal (bitmap/file "flinch-m.png"))
                                        (flip-horizontal (bitmap/file "standby-m.png"))
                                        (flip-horizontal (bitmap/file "dead-m.png")))
                        (make-animation (flip-horizontal (bitmap/file "standby-m.png"))
                                        (flip-horizontal (bitmap/file "attack-m.png"))
                                        (flip-horizontal (bitmap/file "cast-m.png"))
                                        (flip-horizontal (bitmap/file "flinch-m.png"))
                                        (flip-horizontal (bitmap/file "standby-m.png"))
                                        (flip-horizontal (bitmap/file "dead-m.png"))))
        #:position (make-posn (string->number (first p))
                              (string->number (second p)))
        #:level (string->number l) #:mp (string->number mp)
        #:max-mp (string->number mmp) #:current-xp (string->number xp)))

;; save
(define (save d) (write-save d (generate-key (+ 100 (random 100)))))

;; write-save dungeon
(define (write-save d k)
  (write-file "save.txt"
              (string-append
               k " " (enchript-string (dungeon-name d) k) " " (enchript-string (room-name (first (dungeon-rooms d))) k) " "  (enchript-string (send (dungeon-player d) get-name) k) "\n"
               (enchript-string (number->string (send (dungeon-player d) get-health)) k) " " (enchript-string (number->string (send (dungeon-player d) get-max-health)) k) " "
               (enchript-string (number->string (send (dungeon-player d) get-agility)) k) " " (enchript-string (number->string (send (dungeon-player d) get-strength)) k) "\n"
               (write-spells (send (dungeon-player d) get-spells) k) "\n"
               (if (empty? (inventory-weapon (send (dungeon-player d) get-inventory))) (enchript-string "empty" k)
                   (enchript-string (send (inventory-weapon (send (dungeon-player d) get-inventory)) get-name) k)) "\n"
                                                                                                                   (write-items (inventory-equiped (send (dungeon-player d) get-inventory)) k) "\n"
                                                                                                                   (write-items (first (inventory-equipment (send (dungeon-player d) get-inventory))) k) "\n"
                                                                                                                   (write-items (second (inventory-equipment (send (dungeon-player d) get-inventory))) k) "\n"
                                                                                                                   (write-items (third (inventory-equipment (send (dungeon-player d) get-inventory))) k) "\n"
                                                                                                                   (write-items (fourth (inventory-equipment (send (dungeon-player d) get-inventory))) k) "\n"
                                                                                                                   (write-items (fifth (inventory-equipment (send (dungeon-player d) get-inventory))) k) "\n"
                                                                                                                   (write-items (inventory-consumables (send (dungeon-player d) get-inventory)) k) "\n"
                                                                                                                   (string-append (enchript-string (number->string (send (first (filter (lambda (x) (string=? (send x get-name) "Gold"))
                                                                                                                                                                                        (inventory-miscellaneous (send (dungeon-player d) get-inventory)))) get-number)) k)
                                                                                                                                  " " (write-items (filter (lambda (x) (not (string=? (send x get-name) "Gold")))
                                                                                                                                                           (inventory-miscellaneous (send (dungeon-player d) get-inventory))) k)) "\n"
                                                                                                                                                                                                                                  (enchript-string (number->string (posn-x (send (dungeon-player d) get-position))) k) " " (enchript-string (number->string (posn-y (send (dungeon-player d) get-position))) k) "\n"
                                                                                                                                                                                                                                  (enchript-string (number->string (send (dungeon-player d) get-level)) k) " "
                                                                                                                                                                                                                                  (enchript-string (number->string (send (dungeon-player d) get-mp)) k) " "
                                                                                                                                                                                                                                  (enchript-string (number->string (send (dungeon-player d) get-max-mp)) k) " "
                                                                                                                                                                                                                                  (enchript-string (number->string (send (dungeon-player d) get-current-xp)) k) "\n" (enchript-string (if (eq? (animation-standby (send (dungeon-player d) get-animation)) (flip-horizontal (bitmap/file "standby-m.png"))) "m" "f") k))))

(define VALID-CHARACTERS
  (list "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "!" "'" "," "." "?" "@" "#" "$" "%" "^" "&" "*" "(" ")" "_" "-" "+" "="
        "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "~" "`"
        "<" ">" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))

(define (generate-key n)
  (cond
    [(<= n 0) ""]
    [else (string-append (list-ref VALID-CHARACTERS (random 83))
                         (generate-key (- n 1)))]))

(define (enchript-string s k)
  (cond
    [(string=? s "") ""]
    [else
     (string-append (list-ref VALID-CHARACTERS (modulo (+ (get-list-ref-number (substring s 0 1) VALID-CHARACTERS 0)
                                                          (get-list-ref-number (substring k 0 1) VALID-CHARACTERS 0)) 83))
                    (enchript-string (substring s 1) (string-append (substring k 1) (substring k 0 1))))]))

(define (dechript-string s k)
  (cond
    [(string=? s "") ""]
    [else
     (string-append (list-ref VALID-CHARACTERS (modulo (- (get-list-ref-number (substring s 0 1) VALID-CHARACTERS 0)
                                                          (get-list-ref-number (substring k 0 1) VALID-CHARACTERS 0)) 83))
                    (dechript-string (substring s 1) (string-append (substring k 1) (substring k 0 1))))]))

(define (get-list-ref-number s l n)
  (cond
    [(and (empty? l) (not (empty? s))) false]
    [(string=? s (first l)) n]
    [else (get-list-ref-number s (rest l) (+ n 1))]))


;; write-spells
(define (write-spells l k)
  (cond
    [(empty? l) ""]
    [(empty? (rest l)) (enchript-string (spell-name (first l)) k)]
    [(cons? l) (string-append (enchript-string (spell-name (first l)) k) " " (write-spells (rest l) k))]))

;; write-items
(define (write-items l k)
  (cond
    [(empty? l) ""]
    [(empty? (rest l)) (enchript-string (send (first l) get-name) k)]
    [else (string-append (enchript-string (send (first l) get-name) k) " " (write-items (rest l) k))]))