(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Definitions

;; A world is one of:
;; - area
;; - battle
;; - menu
;; - store
;; - cutscene
;; - book
;; - main-menu

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main-Menu

;; a main-menu is a (make-main-menu LOI save) where:
;; the LOI is a list of images for the opening animation
;; the save is the saved game
(define-struct main-menu (loi save))

(define TESTMAINMENU1 (make-main-menu empty empty))

;; a save is one of:
;; - area
;; - empty

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Area

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Invintory, Consumables, Equipment, Item-books

;; an item-effect is a (make-item-effect symbol int) where:
;; the symbol is one of
;; - 'h
;; - 'a
;; - 's
;; and the int is the magnitude of the items effect
(define-struct item-effect (stat magnitude))

(define TESTITEMEFFECT1 (make-item-effect 'h 5))
(define TESTITEMEFFECT2 (make-item-effect 'a 5))
(define TESTITEMEFFECT3 (make-item-effect 's 5))
(define TESTITEMEFFECT4 (make-item-effect 'h -5))
(define TESTITEMEFFECT5 (make-item-effect 'a -5))
(define TESTITEMEFFECT6 (make-item-effect 's -5))

;; a consumable is a (make-consumable string item-effect value image) where:
;; the string is the consumable's name
;; the item-effect is the items effect
;; the value is the items re-sale value
;; the image is an image of the item
(define-struct consumable (name effect value image))

(define TESTCONSUMABLE1 (make-consumable "TEST ITEM 1" TESTITEMEFFECT1 10 (square 5 'solid 'red)))
(define TESTCONSUMABLE2 (make-consumable "TEST ITEM 2" TESTITEMEFFECT2 11 (square 5 'solid 'blue)))
(define TESTCONSUMABLE3 (make-consumable "TEST ITEM 3" TESTITEMEFFECT3 12 (square 5 'solid 'green)))
(define 5GOLD (make-consumable "Gold" (make-item-effect 'h 0) 5 (square 5 'solid 'gold)))
(define 10GOLD (make-consumable "Gold" (make-item-effect 'h 0) 10 (square 5 'solid 'gold)))

;; an equipment is a (make-equipment string string symbol list-of-item-effects int image) where:
;; the first string is the equipments name
;; the second string is the equipment's discription
;; the symbol is one of:
;; - 'head
;; - 'body
;; - 'legs
;; - 'hands
;; - 'weapon
;; the list of i-e is a list of that equipments effects
;; the int is that items value
;; the image is an image of the item
(define-struct equipment (name description portion effects value image))

(define TESTHEADEQUIPMENT1 (make-equipment "Heirloom Hat" "A warm hat made from the wool of a now extinct species of megafauna." 'head empty 20 (square 10 'solid 'brown)))
(define TESTHEADEQUIPMENT2 (make-equipment "Rusty Helm" "A battered and rusty iron helmet from a disreputable second hand shop." 'head (list TESTITEMEFFECT1 TESTITEMEFFECT5) 21 (square 10 'solid 'gray)))
(define TESTBODYEQUIPMENT1 (make-equipment "Gumshoe Coat" "An old brown trenchcoat. Smells of ciggeret smoke and gunpowder." 'body empty 40 (square 10 'solid 'tan)))
(define TESTBODYEQUIPMENT2 (make-equipment "Ninja Costume" "You live in the shadows." 'body '(TESTITEMEFFECT2 TESTITEMEFFECT4) 42 (square 10 'solid 'black)))
(define TESTLEGSEQUIPMENT1 (make-equipment "Flip-Flops" "Hope you don't plan on walking anywere." 'legs '(TESTITEMEFFECT5) 10 (square 10 'solid 'pink)))
(define TESTLEGSEQUIPMENT2 (make-equipment "Pumped Up Kicks" "You better run." 'legs '(TESTITEMEFFECT3) 11 (square 10 'solid 'white)))
(define TESTHANDSEQUIPMENT1 (make-equipment "Ring of Fire" "I went down down down." 'hands '(TESTITEMEFFECT6) 50 (square 10 'solid 'orange)))
(define TESTHANDSEQUIPMENT2 (make-equipment "Boxing Gloves" "Put up your mits." 'hands '(TESTITEMEFFECT3) 51 (square 10 'solid 'orange)))
(define TESTWEAPONEQUIPMENT1 (make-equipment "Toy Wand" "Its not exactly a weapon." 'wepon empty 30 (square 10 'solid 'black)))
(define TESTWEAPONEQUIPMENT2 (make-equipment "Shinigami Eyes" "You made the deal." 'wepon '(TESTITEMEFFECT4 TESTITEMEFFECT3 TESTITEMEFFECT2) 31 (square 10 'solid 'green)))

;; an item-book is a (make-item-book string LOI) where:
;; the string is the book's name
;; the LOI is the list of the book's pages
(define-struct item-book (name pages))

(define TESTITEMBOOK1 (make-item-book "An Imperial Affliction" (list (square 100 'solid 'red) (square 100 'solid 'blue) (square 100 'solid 'green))))
(define TESTITEMBOOK2 (make-item-book "The Standerd Book of Spells" (list (square 100 'solid 'green) (square 100 'solid 'blue) (square 100 'solid 'red))))

;; an equipment is a (make-equiped equipment equipment equipment equipment equipment) where:
;; the first equipment is the equipment on the players head
;; the first equipment is the equipment on the players body
;; the first equipment is the equipment on the players legs
;; the first equipment is the equipment on the players hands
;; the first equipment is the equipment that is the players weapon
(define-struct equiped (head body legs hands weapon))

(define TESTEQUIPED (make-equiped TESTHEADEQUIPMENT1 TESTBODYEQUIPMENT1 TESTLEGSEQUIPMENT1 TESTHANDSEQUIPMENT1 TESTWEAPONEQUIPMENT1))

;; an invintory is a (make-invintory list-of-consumables list-of-equipment list-of-equipment list-of-item-books) where:
;; the list-of-consumables is a list of the consumable items the player currently has
;; the equpied the equipment the player currently has on OR empty for stores
;; the list-of-equipment is the list of equipment the player has but is not wearing
;; the list-of-item-books is a list of the item books the player currently has
(define-struct invintory (consumables equiped equipment books))

(define TESTINVINTORY (make-invintory (list TESTCONSUMABLE1 TESTCONSUMABLE1 TESTCONSUMABLE1 TESTCONSUMABLE2 TESTCONSUMABLE2 TESTCONSUMABLE3) TESTEQUIPED
                                       (list TESTHEADEQUIPMENT2 TESTBODYEQUIPMENT2 TESTLEGSEQUIPMENT2 TESTHANDSEQUIPMENT2 TESTWEAPONEQUIPMENT2)
                                       (list TESTITEMBOOK1 TESTITEMBOOK2)))
(define TESTSTOREINVINTORY (make-invintory (list TESTCONSUMABLE1 TESTCONSUMABLE2 TESTCONSUMABLE3) empty 
                                           (list TESTHEADEQUIPMENT2 TESTBODYEQUIPMENT2 TESTLEGSEQUIPMENT2 TESTHANDSEQUIPMENT2 TESTWEAPONEQUIPMENT2
                                                 TESTHEADEQUIPMENT1 TESTBODYEQUIPMENT1 TESTLEGSEQUIPMENT1 TESTHANDSEQUIPMENT1 TESTWEAPONEQUIPMENT1)
                                           (list TESTITEMBOOK1 TESTITEMBOOK2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Maps and Tiles

;; a map is a (make-area-map string list-of-list-of-tiles)
(define-struct area-map (name list))

(define TESTMAP1 (list '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)))
(define TESTMAP2 (list '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE3)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE2 TESTTILE2 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE2 TESTTILE2 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE2 TESTTILE2 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE2 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)
                       '(TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1 TESTTILE1)))
;; a tile is a (make-tile image boolean string portal) where:
;; the image is the image of the tile that is exactly 50x50 pixles
;; the boolean is true iff the tile is passable
;; the string is any text that should be displayed when the tile is interacted with
;; the portal is a portal which, if aplicable, is the area the player will be taken to when tile is walked on
(define-struct tile (image passable string portal))

(define TESTTILE1 (make-tile (overlay (square 40 'solid 'pink) (square 50 'solid 'black)) true "" empty))
(define TESTTILE2 (make-tile (square 50 'solid 'white) false "Interaction" empty))
(define TESTTILE3 (make-tile (square 50 'solid 'orange) true "" TESTMAINMENU1))

;; a portal is one of:
;; - empty
;; - world

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Player-Info

;; a player-info is a (make-player-info posn dir) where:
;; the posn is the players position
;; the dir is one of:
;; - 'up
;; - 'down
;; - 'left
;; - 'right
(define-struct player-info (posn dir))

(define TESTPLAYERINFO1 (make-player-info (make-posn 25 25) 'down))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Characters Map-Posns and Character Sprites

;; an attack is a (make-attack string effect list-of-images) where:
;; the string is the attacks name
;; the effect is the spells effect
;; the list of images is a list of images for the attack animation
(define-struct attack (name effect animation))

(define TESTATTACK1 (make-attack "Gorenger Hurricane" 'p-5h '((beside (rectangle 0 0 'solid 'white)
                                                                    (circle 20 'solid 'red))
                                                            (beside (rectangle 5 0 'solid 'white)
                                                                    (circle 20 'solid 'red))
                                                            (beside (rectangle 10 0 'solid 'white)
                                                                    (circle 20 'solid 'red))
                                                            (beside (rectangle 15 0 'solid 'white)
                                                                    (circle 20 'solid 'red))
                                                            (beside (rectangle 20 0 'solid 'white)
                                                                    (circle 20 'solid 'red))
                                                            (beside (rectangle 25 0 'solid 'white)
                                                                    (circle 20 'solid 'yellow))
                                                            (beside (rectangle 30 0 'solid 'white)
                                                                    (circle 20 'solid 'red))
                                                            (beside (rectangle 35 0 'solid 'white)
                                                                    (circle 20 'solid 'red))
                                                            (beside (rectangle 40 0 'solid 'white)
                                                                    (circle 20 'solid 'red))
                                                            (beside (rectangle 45 0 'solid 'white)
                                                                    (circle 20 'solid 'red)))))
(define TESTATTACK2 (make-attack "Eat Cakes" 'e+5h '((circle 20 'solid 'blue)
                                                     (circle 20 'solid 'white)
                                                     (circle 20 'solid 'blue)
                                                     (circle 21 'solid 'white)
                                                     (circle 22 'solid 'blue)
                                                     (circle 23 'solid 'white)
                                                     (circle 24 'solid 'blue)
                                                     (circle 25 'solid 'white)
                                                     (circle 26 'solid 'blue)
                                                     (circle 27 'solid 'white))))
(define TESTATTACK3 (make-attack "Midomerang" 'p-5a '((beside (rectangle 0 0 'solid 'white)
                                                                    (circle 20 'solid 'red))
                                                            (beside (rectangle 5 0 'solid 'white)
                                                                    (circle 20 'solid 'yellow))
                                                            (beside (rectangle 10 0 'solid 'white)
                                                                    (circle 20 'solid 'yellow))
                                                            (beside (rectangle 15 0 'solid 'white)
                                                                    (circle 20 'solid 'yellow))
                                                            (beside (rectangle 20 0 'solid 'white)
                                                                    (circle 20 'solid 'yellow))
                                                            (beside (rectangle 25 0 'solid 'white)
                                                                    (circle 20 'solid 'yellow))
                                                            (beside (rectangle 30 0 'solid 'white)
                                                                    (circle 20 'solid 'yellow))
                                                            (beside (rectangle 35 0 'solid 'white)
                                                                    (circle 20 'solid 'yellow))
                                                            (beside (rectangle 40 0 'solid 'white)
                                                                    (circle 20 'solid 'yellow))
                                                            (beside (rectangle 45 0 'solid 'white)
                                                                    (circle 20 'solid 'yellow)))))
(define TESTATTACK4 (make-attack "Training Montage" 'e+5a '((circle 20 'solid 'blue)
                                                              (circle 20 'solid 'blue)
                                                              (circle 20 'solid 'blue)
                                                              (circle 21 'solid 'blue)
                                                              (circle 22 'solid 'blue)
                                                              (circle 23 'solid 'blue)
                                                              (circle 24 'solid 'blue)
                                                              (circle 25 'solid 'blue)
                                                              (circle 26 'solid 'blue)
                                                              (circle 27 'solid 'blue))))
(define TESTATTACK5 (make-attack "Masky Slash" 'p-5s '((beside (rectangle 0 0 'solid 'white)
                                                                    (circle 20 'solid 'red))
                                                            (beside (rectangle 5 0 'solid 'white)
                                                                    (circle 20 'solid 'white))
                                                            (beside (rectangle 10 0 'solid 'white)
                                                                    (circle 20 'solid 'white))
                                                            (beside (rectangle 15 0 'solid 'white)
                                                                    (circle 20 'solid 'white))
                                                            (beside (rectangle 20 0 'solid 'white)
                                                                    (circle 20 'solid 'white))
                                                            (beside (rectangle 25 0 'solid 'white)
                                                                    (circle 20 'solid 'white))
                                                            (beside (rectangle 30 0 'solid 'white)
                                                                    (circle 20 'solid 'white))
                                                            (beside (rectangle 35 0 'solid 'white)
                                                                    (circle 20 'solid 'white))
                                                            (beside (rectangle 40 0 'solid 'white)
                                                                    (circle 20 'solid 'white))
                                                            (beside (rectangle 45 0 'solid 'white)
                                                                    (circle 20 'solid 'white)))))
(define TESTATTACK6 (make-attack "Xtreem Workout" 'e+5a '((circle 20 'solid 'blue)
                                                              (circle 20 'solid 'red)
                                                              (circle 20 'solid 'red)
                                                              (circle 21 'solid 'red)
                                                              (circle 22 'solid 'red)
                                                              (circle 23 'solid 'red)
                                                              (circle 24 'solid 'red)
                                                              (circle 25 'solid 'red)
                                                              (circle 26 'solid 'red)
                                                              (circle 27 'solid 'red))))

;; an effect is a symbol that is one of:
;; 'p(x)h
;; 'e(x)h
;; 'p(x)a
;; 'e(x)a
;; 'p(x)s
;; 'e(x)s
;; where (x) is an int which represents the attacks base magnitude
;; p represents an attack/spell which effects the player
;; e represents an attack/spell which effects the enemy

;; a battle-animation is a (make-battle-animation LOI image image image) where:
;; the LOI is the player/enemy's standby animation
;; the first image is the player/enemy's flinch frame
;; the second image is the player/enemy's attack frame
;; the third image is the player/enemy's dead frame
(define-struct battle-animation (standby flinch attack dead))

(define TESTBA1 (make-battle-animation '((rectangle 100 200 'solid 'red)
                                         (rectangle 100 200 'solid 'red)
                                         (rectangle 100 200 'solid 'red)
                                         (rectangle 100 200 'solid 'blue)
                                         (rectangle 100 200 'solid 'blue)
                                         (rectangle 100 200 'solid 'green))
                                       (rotate 20 (rectangle 100 200 'solid 'red))
                                       (beside (rectangle 100 200 'solid 'red) (rectangle 50 20 'solid 'red))
                                       (circle 100 'solid 'blue)))

;; a diolague-frame is a (make-diolague-frame string LOI) where:
;; the string is the characters diolague
;; the list-of-images is a list of that characters talking sprite
(define-struct diolague-frame (string loi))

(define TESTDFRAME1 (make-diolague-frame "diolague frame #1" 
                                          '((rectangle 50 100 'solid 'red) 
                                            (rectangle 50 100 'solid 'blue))))
(define TESTDFRAME2 (make-diolague-frame "diolague frame #2" 
                                          '((rectangle 50 100 'solid 'red) 
                                            (rectangle 50 100 'solid 'blue) 
                                            (rectangle 50 100 'solid 'yellow))))
(define TESTDFRAME3 (make-diolague-frame "" '((rectangle 50 100 'solid 'red) 
                                               (rectangle 50 100 'solid 'blue) 
                                               (rectangle 50 100 'solid 'yellow))))

;; a sprite is a (make-sprite image image image) where:
;; front is the characters front view image
;; side is the characters side view (facing right) image
;; back is the characters back view image
(define-struct sprite (front back side))

(define TESTSPRITE1 (make-sprite (rectangle 25 50 'solid 'red)
                                 (rectangle 25 50 'solid 'green)
                                 (rectangle 25 50 'solid 'brown)))

;; a map-posn is a (make-map-posn int int) where:
;; the first int is the number of tiles from the left the item is (w/ 1 being the first tile)
;; the second int is the number of tiles from the top the item is (w/ 1 being the first tile)
(define-struct map-posn (x y))

;; a diolague is one of:
;; - empty
;; - portal
;; - (cons diolague-frame diolague)

(define TESTD1 (list TESTDFRAME1 TESTDFRAME2 TESTDFRAME3))
(define TESTD2 (list TESTDFRAME1 TESTDFRAME2 TESTDFRAME3 TESTMAINMENU1))

;; a character is a (make-character sprite map-posn diolague) where:
;; sprite is the characters sprite
;; dir is the characters direction as a symbol
;; map-posn is the characters position
;; the diolague is the characters diolague
(define-struct character (sprite dir posn diolague))

(define TESTCHARACTER1 (make-character TESTSPRITE1 'up (make-map-posn 2 2) TESTD1))
(define TESTCHARACTER2 (make-character TESTSPRITE1 'up (make-map-posn 1 2) TESTD2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Encounters, Enemies, Attacks, Effects, and Battle Animation

;; an enemy is a (make-enemy string int int list-of-attacks battle-animation symbol int list-of-items) where:
;; the string is the enemy's name
;; the first int is the enemy's health
;; the second int is the enemy's agility
;; the third int is the enemy's strength
;; the list of attacks is a list of the enemy's attacks
;; the battle animation is the enemy's battle animation
;; the symbol is one of
;; - 'wood
;; - 'fire
;; - 'earth
;; - 'metal
;; - 'water
;; - 'none
;; which represent that enemies weekness
;; the fourth int is the amount of xp the enemy generates
;; the list-of-items is a list of the items the player will gain from the enemy
(define-struct enemy (name health agiligy strength attacks ba weekness xp loot))

(define TESTENEMY1 (make-enemy "TEST1" 10 10 10 (list TESTATTACK1) TESTBA1 'wood 10 empty))
(define TESTENEMY2 (make-enemy "TEST2" 10 10 10 (list TESTATTACK2) TESTBA1 'fire 10 empty))
(define TESTENEMY3 (make-enemy "TEST3" 10 10 10 (list TESTATTACK3) TESTBA1 'earth 10 empty))
(define TESTENEMY4 (make-enemy "TEST4" 10 10 10 (list TESTATTACK4) TESTBA1 'metal 10 empty))
(define TESTENEMY5 (make-enemy "TEST5" 10 10 10 (list TESTATTACK5) TESTBA1 'water 10 empty))
(define TESTENEMY6 (make-enemy "TEST6" 10 10 10 (list TESTATTACK6) TESTBA1 'none 10 empty))
(define TESTENEMY7 (make-enemy "TEST7" 100 10 10 (list TESTATTACK1 TESTATTACK2 TESTATTACK3 TESTATTACK4 TESTATTACK5 TESTATTACK6) TESTBA1 'none 10 empty))
(define TESTENEMY8 (make-enemy "TEST8" 10 10 10 (list TESTATTACK1) TESTBA1 'none 10 (list 5GOLD)))
(define TESTENEMY9 (make-enemy "TEST9" 10 10 10 (list TESTATTACK1) TESTBA1 'none 10 (list 10GOLD TESTCONSUMABLE1 TESTCONSUMABLE2)))
(define TESTENEMY10 (make-enemy "TEST10" 10 10 10 (list TESTATTACK1) TESTBA1 'none 10 (list TESTCONSUMABLE1 TESTCONSUMABLE1)))

;; an encounter is a (make-encounter int list-of-enemies) where:
;;  - the int is a number between 0 and 99 (-1 for no chance) representing the % chance
;; that a battle will occur on any given step
;; - the list-of-enemies is the list of possible enemie encounters for the given area
(define-struct encounter (prob loe))

(define TESTENCOUNTER-1 (make-encounter -1 empty))
(define TESTENCOUNTER1 (make-encounter 10 (list TESTENEMY1)))
(define TESTENCOUNTER2 (make-encounter 10 (list TESTENEMY2)))
(define TESTENCOUNTER3 (make-encounter 10 (list TESTENEMY3)))
(define TESTENCOUNTER4 (make-encounter 10 (list TESTENEMY4)))
(define TESTENCOUNTER5 (make-encounter 10 (list TESTENEMY5)))
(define TESTENCOUNTER6 (make-encounter 10 (list TESTENEMY6)))
(define TESTENCOUNTER7 (make-encounter 10 (list TESTENEMY7)))
(define TESTENCOUNTER8 (make-encounter 10 (list TESTENEMY8)))
(define TESTENCOUNTER9 (make-encounter 10 (list TESTENEMY9)))
(define TESTENCOUNTER10 (make-encounter 10 (list TESTENEMY10)))
(define TESTENCOUNTER11 (make-encounter 10 (list TESTENEMY1 TESTENEMY2 TESTENEMY3 TESTENEMY4 TESTENEMY5 TESTENEMY6)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Player, Spells, and Player Animation

;; a level is a (make-level int int) where: 
;; the first int is the players current level
;; the second int is the amount of xp needed to reach the next level
(define-struct level (level xp))

(define DEFLEVEL1 (make-level 1 100))

;; a spell is a (make-spell string int effect list-of-images) where:
;; the string is the spell's name
;; the int is the level requisit to preform the spell
;; the effect is the spell's effect
;; the list-of-images is the list of images for the spell animation
;; NOTE: in battle, usable items are envoked as spells for simplicity
(define-struct spell (name level effect animation)) 

(define TESTSPELL1 (make-spell "Test 1" 1 'p+5h '((circle 20 'solid 'red)
                                                (circle 20 'solid 'red)
                                                (circle 20 'solid 'red)
                                                (circle 21 'solid 'red)
                                                (circle 22 'solid 'red)
                                                (circle 23 'solid 'red)
                                                (circle 24 'solid 'red)
                                                (circle 25 'solid 'red)
                                                (circle 26 'solid 'red)
                                                (circle 27 'solid 'red))))
(define TESTSPELL2 (make-spell "Test 2" 1 'e-5h '((beside (circle 20 'solid 'red) (rectangle 20 0 'solid 'white))
                                                (beside (circle 20 'solid 'red) (rectangle 25 0 'solid 'white))
                                                (beside (circle 20 'solid 'red) (rectangle 30 0 'solid 'white))
                                                (beside (circle 20 'solid 'red) (rectangle 35 0 'solid 'white))
                                                (beside (circle 20 'solid 'red) (rectangle 40 0 'solid 'white))
                                                (beside (circle 20 'solid 'red) (rectangle 45 0 'solid 'white))
                                                (beside (circle 20 'solid 'red) (rectangle 50 0 'solid 'white))
                                                (beside (circle 20 'solid 'red) (rectangle 55 0 'solid 'white))
                                                (beside (circle 20 'solid 'red) (rectangle 60 0 'solid 'white))
                                                (beside (circle 20 'solid 'red) (rectangle 65 0 'solid 'white)))))
(define TESTSPELL3 (make-spell "Test 3" 1 'p+5a '((circle 20 'solid 'blue)
                                                (circle 20 'solid 'blue)
                                                (circle 20 'solid 'blue)
                                                (circle 21 'solid 'blue)
                                                (circle 22 'solid 'blue)
                                                (circle 23 'solid 'blue)
                                                (circle 24 'solid 'blue)
                                                (circle 25 'solid 'blue)
                                                (circle 26 'solid 'blue)
                                                (circle 27 'solid 'blue))))
(define TESTSPELL4 (make-spell "Test 4" 1 'e-5a '((beside (circle 20 'solid 'blue) (rectangle 20 0 'solid 'white))
                                                (beside (circle 20 'solid 'blue) (rectangle 25 0 'solid 'white))
                                                (beside (circle 20 'solid 'blue) (rectangle 30 0 'solid 'white))
                                                (beside (circle 20 'solid 'blue) (rectangle 35 0 'solid 'white))
                                                (beside (circle 20 'solid 'blue) (rectangle 40 0 'solid 'white))
                                                (beside (circle 20 'solid 'blue) (rectangle 45 0 'solid 'white))
                                                (beside (circle 20 'solid 'blue) (rectangle 50 0 'solid 'white))
                                                (beside (circle 20 'solid 'blue) (rectangle 55 0 'solid 'white))
                                                (beside (circle 20 'solid 'blue) (rectangle 60 0 'solid 'white))
                                                (beside (circle 20 'solid 'blue) (rectangle 65 0 'solid 'white)))))
(define TESTSPELL5 (make-spell "Test 5" 1 'p+5s '((circle 20 'solid 'pink)
                                                (circle 20 'solid 'pink)
                                                (circle 20 'solid 'pink)
                                                (circle 21 'solid 'pink)
                                                (circle 22 'solid 'pink)
                                                (circle 23 'solid 'pink)
                                                (circle 24 'solid 'pink)
                                                (circle 25 'solid 'pink)
                                                (circle 26 'solid 'pink)
                                                (circle 27 'solid 'pink))))
(define TESTSPELL6 (make-spell "Test 6" 1 'e-5s '((beside (circle 20 'solid 'pink) (rectangle 20 0 'solid 'white))
                                                (beside (circle 20 'solid 'pink) (rectangle 25 0 'solid 'white))
                                                (beside (circle 20 'solid 'pink) (rectangle 30 0 'solid 'white))
                                                (beside (circle 20 'solid 'pink) (rectangle 35 0 'solid 'white))
                                                (beside (circle 20 'solid 'pink) (rectangle 40 0 'solid 'white))
                                                (beside (circle 20 'solid 'pink) (rectangle 45 0 'solid 'white))
                                                (beside (circle 20 'solid 'pink) (rectangle 50 0 'solid 'white))
                                                (beside (circle 20 'solid 'pink) (rectangle 55 0 'solid 'white))
                                                (beside (circle 20 'solid 'pink) (rectangle 60 0 'solid 'white))
                                                (beside (circle 20 'solid 'pink) (rectangle 65 0 'solid 'white)))))

(define SPELL-LIST '(TESTSPELL1 TESTSPELL2 TESTSPELL3 TESTSPELL4 TESTSPELL5 TESTSPELL6))

;; a player-animation is a (make-player-animation image image image LOI LOI LOI) where:
;; the first image is the players still front image
;; the second image is the players still side (right) image
;; the third image is the players still back image
;; the first LOI is the players walking forward animation
;; the second LOI is the player's walking side (right) animation
;; the third LOI is the player's walking (back) animation
(define-struct player-animation (front side back m-front m-side m-back))

(define TESTPA1 (make-player-animation (rectangle 25 50 'solid 'pink) (rectangle 25 50 'solid 'green) (rectangle 25 50 'solid 'purple)
                                       '((rectangle 25 50 'solid 'pink) (rectangle 25 50 'solid 'red) (rectangle 25 50 'solid 'purple) (rectangle 25 50 'solid 'yellow))
                                       '((rectangle 25 50 'solid 'green) (rectangle 25 50 'solid 'blue) (rectangle 25 50 'solid 'purple) (rectangle 25 50 'solid 'red))
                                       '((rectangle 25 50 'solid 'purple) (rectangle 25 50 'solid 'red) (rectangle 25 50 'solid 'blue) (rectangle 25 50 'solid 'orange))))

;; a player is a (make-player string level int int int list-of-spells battle-animation player-animation) where:
;; the string is the player's name
;; the level is the player's level
;; the first int is the players health
;; the second int is the players agility
;; the third int is the players strength
;; the list-of-spells is the list of all possible spells the player can use
;; the battle-animation is the player's battle animation
;; the player animation is the player's player animation
(define-struct player (name level health agility streingth spells ba pa))

(define TESTPLAYER1 (make-player "Test 1" DEFLEVEL1 10 10 10 SPELL-LIST TESTBA1 TESTPA1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Map-Items

;; a map-item is a (make-map-item image map-posn item) where:
;; the image is the image of the item that will appere on the map
;; the map-posn is the position of the item on the map
;; the item is the item that will appere in the players invintory if the item is obtained
(define-struct map-item (image posn item))

(define TESTMAPITEM1 (make-map-item (circle 10 'solid 'red) (make-map-posn 1 4) TESTCONSUMABLE1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Area

;; an area is a (make-area area-map player items encounters party invintory text frame) where:
;; the area-map is the area-map of the explorable area
;; the player-info is the player's posn and direction
;; characters is a list of characters on the map
;; items is a list of map-items on the map
;; encounters is the encounter information for that area
;; the player is the players information and stats
;; the invintory is the players invintory
;; text is one of:
;; - LOS
;; - diolague
(define-struct area (area-map player-info characters items encounters player invintory text))

(define TESTAREA1 (make-area TESTMAP1 TESTPLAYERINFO1 empty empty TESTENCOUNTER-1 TESTPLAYER1 TESTINVINTORY ""))
(define TESTAREA2 (make-area TESTMAP1 TESTPLAYERINFO1 (list TESTCHARACTER1 TESTCHARACTER2) (list TESTMAPITEM1) TESTENCOUNTER1 TESTPLAYER1 TESTINVINTORY ""))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Battle

;; a battle is one of
;; - standby-phase
;; - enemy-phase
;; - player-decision-phase
;; - player-action-phase
;; - battle-end-phase

;; standby --> enemy --> player-decision --> player-action --> enemy ... --> end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Standby-Phase
;; during this phase both the player and the enemy don't do anything. Begins the fight.

;; a standby-phase is a (make-standby-phase player enemy area int) where:
;; the player is the player
;; the invintory is the player's invintory
;; the enemy is the enemy
;; ;; the area is the area that the player will go back to, the area is the area the player left to enter battle
;; the int is a number that represents number of ticks sence phase start
(define-struct standby-phase (player invintory enemy area time))
;; standby-phase length
(define SB-PHASE-LENGTH 36)

(define TESTSBP1 (make-standby-phase TESTPLAYER1 TESTINVINTORY TESTENEMY1 TESTAREA1 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enemy-Phase
;; during this phase the enemy attacks the player and any effects are applied

;; an enemy-phase is a (make-enemy-phase player enemy attack text area) where:
;; the player is the player (w/ attacks effects applied)
;; the invintory is the player's invintory
;; the enemy is the enemy (w/ attacks effects applied)
;; the attack is the attack the enemy has used
;; the text is the text that is being displayed
;; the area is the area that the player will go back to 
(define-struct enemy-phase (player invintory enemy attack text area))

(define TESTEP1 (make-enemy-phase TESTPLAYER1 TESTINVINTORY TESTENEMY1 TESTATTACK1 "attack" TESTAREA1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Player-Decision-Phase
;; during this phase the player decides which spell or item to use

;; a player-decision-phase is a (make-player-decision-phase player enemy boolean area) where
;; the player is the player
;; the invintory is the player's invintory
;; the enemy is the enemy
;; the boolean is true iff the player has up the items screen
;; the area is the area that the player will go back to 
(define-struct player-decision-phase (player invintory enemy bool area))

(define TESTPDP1 (make-player-decision-phase TESTPLAYER1 TESTINVINTORY TESTENEMY1 false TESTAREA1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Player-Action-Phase
;; during this phase the players spell/item takes effect and changes to area are applied

;; a player-action-phase is a (make-player-action-phase player enemy spell text area) where:
;; the player is the player (w/ necessary changes applied)
;; the invintory is the players invintory (w/ necessary changes applied)
;; the enemy is the enemy (w/ necessary changes applied)
;; the spell is the spell that is being used
;; the text is the text that is being displayed
;; the area is the area that the player will go back to (w/ necessary changes applied)
(define-struct player-action-phase (player invintory enemy spell text area))

(define TESTPAP1 (make-player-action-phase TESTPLAYER1 TESTINVINTORY TESTENEMY1 TESTSPELL1 "spell" TESTAREA1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Battle-End-Phase
;; this is the phase that happens after the battle is won or lost

;; a battle-end-phase is a (make-battle-end-phase player enemy text int area) where
;; the player is the player
;; the invintory is the player's invintory
;; the enemy is the enemy 
;; the text is the text that is to be displayed
;; int is a countdown to when the phase will be over
;; the area is the area that the player will go back to (if not dead)
(define-struct battle-end-phase (player invintory enemy text int area))

(define TESTBEP1 (make-battle-end-phase TESTPLAYER1 TESTINVINTORY (make-enemy "DEAD" 0 10 10 (list TESTATTACK1) TESTBA1 'wood 10 empty) "you win" 0 TESTAREA1))
(define TESTBEP2 (make-battle-end-phase TESTPLAYER1 TESTINVINTORY (make-enemy "DEAD" 0 10 10 (list TESTATTACK1) TESTBA1 'wood 10 empty) "you win" (+  SB-PHASE-LENGTH 1) TESTAREA1))
(define TESTBEP3 (make-battle-end-phase (make-player "Dead" DEFLEVEL1 0 10 10 SPELL-LIST TESTBA1 TESTPA1) TESTINVINTORY TESTENEMY1 "you loose" 0 TESTAREA1))
(define TESTBEP4 (make-battle-end-phase (make-player "Dead" DEFLEVEL1 0 10 10 SPELL-LIST TESTBA1 TESTPA1) TESTINVINTORY TESTENEMY1 "you loose" (+  SB-PHASE-LENGTH 1) TESTAREA1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu

;; a menu is a (make-menu player invintory area) where:
;; the player is the player
;; the invintory is the players invintory
;; the area is the world to which the player will return (after it is edited)
(define-struct menu (player invintory area))

(define TESTMENU1 (make-menu TESTPLAYER1 TESTINVINTORY TESTAREA1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Store

;; a store is a (make-store invintory invintory int area) where:
;; the first invintory is the player's invintory
;; the second invintory is the store's invintory
;; the int is the markup between retail price and value
;; the area is the area to which the player will return
(define-struct store (player-i store-i markup area))

(define TESTSTORE1 (make-store TESTINVINTORY TESTSTOREINVINTORY 1.5 TESTAREA1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cutscene

;; a cutscene is a (make-cutscene list-of-images portal) where:
;; the list of images are the images remaining in the animation
;; the portal is the world to which the player will go after the cutscene
(define-struct cutscene (loi portal))

(define TESTCUTSCENE1 (make-cutscene (list (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'red)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)
                             (square 10 'solid 'blue)) TESTMAINMENU1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Book

;; a book is a (make-book list-of-images portal) where:
;; the loi are the images of the pages of the book
;; the portal is the world where the player will go when done reading
(define-struct book (pages portal))

(define TESTBOOK1 (make-book (list (square 100 'solid 'blue) (square 100 'solid 'red) (square 100 'solid 'blue)) TESTAREA1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Render

;; render : world --> image
;; renders the world as an image
(define (render w) 
  (cond
    [(area? w) (render-area w)]
    [(standby-phase? w) (render-standby-phase w)]
    [(enemy-phase? w) (render-enemy-phase w)]
    [(player-decision-phase? w) (render-player-decision-phase w)]
    [(player-action-phase? w) (render-player-action-phase w)]
    [(battle-end-phase? w) (render-battle-end-phase w)]
    [(store? w) (render-store w)]
    [(cutscene? w) (first (cutscene-loi w))]
    [(book? w) (first (book-pages w))]
    [(main-menu? w)(render-main-menu w)]))

;; Tests
(check-expect (render TESTAREA1) (render-area TESTAREA1))
(check-expect (render TESTSBP1) (render-standby-phase TESTSBP1))
(check-expect (render TESTEP1) (render-enemy-phase TESTEP1))
(check-expect (render TESTPDP1) (render-player-decision-phase TESTPDP1))
(check-expect (render TESTPAP1) (render-player-action-phase TESTPAP1))
(check-expect (render TESTBEP1) (render-battle-end-phase TESTBEP1))
(check-expect (render TESTSTORE1) (render-store TESTSTORE1))
(check-expect (render TESTBOOK1) (square 100 'solid 'blue))
(check-expect (render TESTCUTSCENE1) (square 10 'solid 'red))
(check-expect (render TESTMAINMENU1) (render-main-menu TESTMAINMENU1))

;; render-area : area --> image
;; renders an area as an image
(define (render-area a) a)

;; render-standby-phase : standby-phase --> image
;; renders a standby-phase as an image
(define (render-standby-phase s) s)

;; render-enemy-phase : enemy-phase --> image
;; renders an enemy-phase as an image
(define (render-enemy-phase e) e)

;; render-player-decision-phase : player-decision-phase --> image
;; renders a player-decision-phase as an image
(define (render-player-decision-phase p) p)

;; render-player-action-phase : player-action-phase --> image
;; renders a player-action-phase as an image
(define (render-player-action-phase p) p)

;; render-battle-end-phase : battle-end-phase --> image
;; renders a battle-end-phase as an image
(define (render-battle-end-phase b) b)

;; render-store : store --> image
;; renders a store as an image
(define (render-store s) s)

;; render-main-menu : main-menu --> image
;; renders a main-menu as an image
(define (render-main-menu m) m)


    
