#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require "combat.rkt")
(require "items.rkt")
(require "spells.rkt")
(require "characters.rkt")
(provide tile% 
         (struct-out room)
         (struct-out portal)
         (struct-out dungeon)
         (all-defined-out))

(define PLAYER-SPEED 15)
;; ----------------------------------------------------------------------------
(define base-tile<%>
  (interface ()
    get-image ;; gets tiles image
    passable? ;; true iff tile is passable
    portal? ;; true iff tile contains a portal
    ))

(define tile%
  (class* object% (base-tile<%>)
    (super-new)
    (init-field
     image ;; an image that is an image of the tile
     passable ;; true iff tile is passable
     portal ;; is one of: empty portal
     )
    (define/public (get-image) image)
    (define/public (passable?) passable)
    (define/public (portal?) (not (empty? portal)))))

(define W (new tile%
                   [image (bitmap/file "dirt.jpg")]
                   [passable true]
                   [portal empty]))

(define B (new tile%
                   [image (bitmap/file "stone.jpg")]
                   [passable false]
                   [portal empty]))

(define TILES1 (list
                (list B B B B B B B B B B B B B B B B B B B B B B B B)
                (list B W W B W W W W B W W W B W W B B B B B W W W B)
                (list B W B B W B B W W W B W B W B B W W W W W B W B)
                (list B W B B W W B B B B B W W W W W W B W B B B W B)
                (list B W B B B W B W W W W W B W B B B B W B W B W B)
                (list B W W W W W B W B B W B B W B W W W W W W W W B)
                (list B B B B B W W W B B W B B W B W B B B B W B B B)
                (list B W W W W W B W W W W W W W W W W W W W W W W B)
                (list B B B B B W B W B B W B B W B B W B B B W B W B)
                (list B W W W B W B W B B W B B W B B W B W W W B W B)
                (list B W B W B W B W B B W B B W B B W B W B B B W B)
                (list B W B W B W W W W W W W W W W W W B W B W W W B)
                (list B W B B B W B B B B W B B W B B W B B B W B B B)
                (list B W W W W W W W W W W B W W W B W W W W W B B B)
                (list B B B B B B B B B B B B B B B B B B B B B B B B)))

;; a room is a (make-room string list-of-tiles num list-of-npcs) where:
;; - the string is the name of the room
;; - the list-of-(list-of-tiles) are th
;; - the number is the proboblility you will encounter an enemy on a givin step
;; - the list-of-npcs is the list of all possible npcs you could face
(define-struct room (name tiles encounter-probability possible-encounters))

(define TESTROOM1 (make-room "test room 1" TILES1 5 (list NPC)))

;; a portal is a (make-portal string posn) where
;; the string is the name of the room to which the portal leads
;; the posn is the position in the room to which the portal leads
(define-struct portal (name position))

;; a dungen is a (make-dungeon player list-of-rooms loi)
(define-struct dungeon (player rooms images))

(define TESTDUNGEON1 (make-dungeon SPELLSWORD (list TESTROOM1) empty))

;; RENDER -----------------------------------------------------------------------
(define (render-dungeon d)
  (overlay
   (if (empty? (dungeon-images d)) (square 0 'solid 'blue) (first (dungeon-images d)))
   (render-room (send (dungeon-player d) get-position)
                (send (dungeon-player d) get-map-animation)
                (first (dungeon-rooms d)))))

(define (render-room p a r)
  (overlay
   (map-animation-forward-stationary a)
   (place-image
    (tiles->image (room-tiles r))
    (+ 405 (- (/ (image-width (tiles->image (room-tiles r))) 2) (posn-x p)))
    (+ 315 (- (/ (image-height (tiles->image (room-tiles r))) 2) (posn-y p)))
    (overlay/align "left" "bottom" (text (room-name r) 15 'red) (rectangle 810 630 'solid 'black)))))

(define (tiles->image t)
  (cond
    [(empty? t) (square 0 'solid 'gold)]
    [(cons? t) (above (render-tile-row (first t))
                      (tiles->image (rest t)))]))

(define (render-tile-row r)
  (cond
    [(empty? r) (square 0 'solid 'red)]
    [(cons? r) (beside (send (first r) get-image)
                       (render-tile-row (rest r)))]))

;; TOCK -----------------------------------------------------------------------

;; dungeon-tock : dungeon --> dungeon
(define (dungeon-tock d)
  (cond
    [(empty? (dungeon-images d)) d]
    [(= 1 (image-height (first (dungeon-images d))))
     (make-combat (dungeon-player d)
                  (list-ref (room-possible-encounters (first (dungeon-rooms d)))
                            (random (length (room-possible-encounters (first (dungeon-rooms d))))))
                  'p
                  'm
                  empty)]
    [else (make-dungeon (dungeon-player d)
                        (dungeon-rooms d)
                        (rest (dungeon-images d)))]))

;; KEY-HANDLING -------------------------------------------------------------------

;; handle-dungeon-key : dungeon --> dungeon
(define (handle-dungeon-key d k)
  (if (or
       (not (empty? (dungeon-images d)))
       (not (or (key=? k "w") (key=? k "s")
                (key=? k "a") (key=? k "d"))))
      d
      (cond
        [(> (room-encounter-probability (first (dungeon-rooms d))) (random 1000)) (make-dungeon (dungeon-player d)
                                                                                                (dungeon-rooms d)
                                                                                                (append
                                                                                                 (make-list 20 (overlay
                                                                                                 (text "An enemy appears!" 20 'black)
                                                                                                 (rectangle 220 40 'outline 'black)
                                                                                                 (rectangle 220 40 'solid 'gray)))
                                                                                                 (list (square 1 'solid 'blue))))]
        [(and (key=? k "w") (enough-space-above? d)) (make-dungeon 
                                                      (send (dungeon-player d) clone #:position 
                                                            (make-posn
                                                             (posn-x (send (dungeon-player d) get-position))
                                                             (- (posn-y (send (dungeon-player d) get-position)) PLAYER-SPEED)))
                                                      (dungeon-rooms d)
                                                      (dungeon-images d))]
        [(and (key=? k "s") (enough-space-below? d)) (make-dungeon 
                                                      (send (dungeon-player d) clone #:position 
                                                            (make-posn
                                                             (posn-x (send (dungeon-player d) get-position))
                                                             (+ (posn-y (send (dungeon-player d) get-position)) PLAYER-SPEED)))
                                                      (dungeon-rooms d)
                                                      (dungeon-images d))]
        [(and (key=? k "a") (enough-space-left? d)) (make-dungeon 
                                                     (send (dungeon-player d) clone #:position 
                                                           (make-posn
                                                            (- (posn-x (send (dungeon-player d) get-position)) PLAYER-SPEED)
                                                            (posn-y (send (dungeon-player d) get-position))))
                                                     (dungeon-rooms d)
                                                     (dungeon-images d))]
        [(and (key=? k "d") (enough-space-right? d)) (make-dungeon 
                                                      (send (dungeon-player d) clone #:position 
                                                            (make-posn
                                                             (+ (posn-x (send (dungeon-player d) get-position)) PLAYER-SPEED)
                                                             (posn-y (send (dungeon-player d) get-position))))
                                                      (dungeon-rooms d)
                                                      (dungeon-images d))]
        [else d])))

;; enough-space-above? : dungeon --> boolean
(define (enough-space-above? d) 
  (not
   (or (>= (/ (image-height (map-animation-forward-stationary (send (dungeon-player d) get-map-animation))) 2)
           (posn-y (send (dungeon-player d) get-position))) 
       (not (send (get-tile (make-posn (posn-x (send (dungeon-player d) get-position)) (- (posn-y (send (dungeon-player d) get-position))
                                                                                          (/ (image-height (map-animation-forward-stationary (send (dungeon-player d) get-map-animation))) 2)))
                            (room-tiles (first (dungeon-rooms d)))) passable?)))))

;; get-tile : posn lolot --> tile
(define (get-tile p l)
  (list-ref (list-ref l (round-down (/ (posn-y p) (image-height (send (first (first l)) get-image)))))
            (round-down (/ (posn-x p) (image-width (send (first (first l)) get-image))))))

;; round-down
(define (round-down n)
  (cond
    [(> 1 n) 0]
    [else (+ 1 (round-down (- n 1)))]))

;; enough-space-below? : dungeon --> boolean
(define (enough-space-below? d)
  (not
   (or (<= (- (* (image-height (send (first (first (room-tiles (first (dungeon-rooms d))))) get-image))
                 (length (room-tiles (first (dungeon-rooms d)))))
              (/ (image-height (map-animation-forward-stationary (send (dungeon-player d) get-map-animation))) 2))
           (posn-y (send (dungeon-player d) get-position))) 
       (not (send (get-tile (make-posn (posn-x (send (dungeon-player d) get-position)) (+ (posn-y (send (dungeon-player d) get-position))
                                                                                          (/ (image-height (map-animation-forward-stationary (send (dungeon-player d) get-map-animation))) 2)))
                            (room-tiles (first (dungeon-rooms d)))) passable?)))))

;; enough-space-left? : dungeon --> boolean
(define (enough-space-left? d)
  (not
   (or (>= (/ (image-width (map-animation-forward-stationary (send (dungeon-player d) get-map-animation))) 2)
           (posn-x (send (dungeon-player d) get-position))) 
       (not (send (get-tile (make-posn (- (posn-x (send (dungeon-player d) get-position))
                                          (/ (image-width (map-animation-forward-stationary (send (dungeon-player d) get-map-animation))) 2))
                                       (posn-y (send (dungeon-player d) get-position)))
                            (room-tiles (first (dungeon-rooms d)))) passable?)))))

;; enough-space-right? : dungeon --> boolean
(define (enough-space-right? d)
  (not
   (or (<= (- (* (image-width (send (first (first (room-tiles (first (dungeon-rooms d))))) get-image))
                 (length (first (room-tiles (first (dungeon-rooms d))))))
              (/ (image-width (map-animation-forward-stationary (send (dungeon-player d) get-map-animation))) 2))
           (posn-x (send (dungeon-player d) get-position))) 
       (not (send (get-tile (make-posn (+ (posn-x (send (dungeon-player d) get-position))
                                          (/ (image-width (map-animation-forward-stationary (send (dungeon-player d) get-map-animation))) 2))
                                       (posn-y (send (dungeon-player d) get-position)))
                            (room-tiles (first (dungeon-rooms d)))) passable?)))))
