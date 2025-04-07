;; Issuer Verification Contract
;; This contract validates legitimate corporate entities

(define-data-var admin principal tx-sender)

;; Map to store verified issuers
(define-map verified-issuers principal bool)

;; Error codes
(define-constant err-not-admin (err u100))
(define-constant err-already-verified (err u101))
(define-constant err-not-verified (err u102))

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Add a new verified issuer
(define-public (add-verified-issuer (issuer principal))
  (begin
    (asserts! (is-admin) err-not-admin)
    (asserts! (is-none (map-get? verified-issuers issuer)) err-already-verified)
    (ok (map-set verified-issuers issuer true))))

;; Remove a verified issuer
(define-public (remove-verified-issuer (issuer principal))
  (begin
    (asserts! (is-admin) err-not-admin)
    (asserts! (is-some (map-get? verified-issuers issuer)) err-not-verified)
    (ok (map-delete verified-issuers issuer))))

;; Check if an issuer is verified
(define-read-only (is-verified-issuer (issuer principal))
  (default-to false (map-get? verified-issuers issuer)))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) err-not-admin)
    (ok (var-set admin new-admin))))
