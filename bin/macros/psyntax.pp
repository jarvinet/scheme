;;; psyntax.pp
;;; automatically generated from psyntax.ss
;;; Fri Jul 12 14:30:13 EST 2002
;;; see copyright notice in psyntax.ss

((lambda ()
   (letrec ((noexpand62 '"noexpand")
            (annotation?126 (lambda (x901) '#f))
            (top-level-eval-hook127
             (lambda (x1941) (eval (list noexpand62 x1941))))
            (local-eval-hook128
             (lambda (x902) (eval (list noexpand62 x902))))
            (error-hook129
             (lambda (who1940 why1938 what1939)
               (error who1940 '"~a ~s" why1938 what1939)))
            (put-global-definition-hook134
             (lambda (symbol904 val903) ($sc-put-cte symbol904 val903)))
            (get-global-definition-hook135
             (lambda (symbol1937) (getprop symbol1937 '*sc-expander*)))
            (get-import-binding136
             (lambda (symbol906 token905) (getprop symbol906 token905)))
            (generate-id137
             ((lambda (digits1923)
                ((lambda (base1925 session-key1924)
                   (letrec ((make-digit1926
                             (lambda (x1936)
                               (string-ref digits1923 x1936)))
                            (fmt1927
                             (lambda (n1930)
                               ((letrec ((fmt1931
                                          (lambda (n1933 a1932)
                                            (if (< n1933 base1925)
                                                (list->string
                                                  (cons (make-digit1926
                                                          n1933)
                                                        a1932))
                                                ((lambda (r1935 rest1934)
                                                   (fmt1931
                                                     rest1934
                                                     (cons (make-digit1926
                                                             r1935)
                                                           a1932)))
                                                 (modulo n1933 base1925)
                                                 (quotient
                                                   n1933
                                                   base1925))))))
                                  fmt1931)
                                n1930
                                '()))))
                     ((lambda (n1928)
                        (lambda (name1929)
                          (begin (set! n1928 (+ n1928 '1))
                                 (string->symbol
                                   (string-append
                                     session-key1924
                                     (fmt1927 n1928))))))
                      '-1)))
                 (string-length digits1923)
                 '"_"))
              '"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$%&*/:<=>?~_^.+-"))
            (build-sequence236
             (lambda (src908 exps907)
               (if (null? (cdr exps907))
                   (car exps907)
                   (cons 'begin exps907))))
            (build-letrec237
             (lambda (src1922 vars1919 val-exps1921 body-exp1920)
               (if (null? vars1919)
                   body-exp1920
                   (list 'letrec
                         (map list vars1919 val-exps1921)
                         body-exp1920))))
            (build-body238
             (lambda (src912 vars909 val-exps911 body-exp910)
               (build-letrec237 src912 vars909 val-exps911 body-exp910)))
            (make-syntax-object250
             (lambda (expression1918 wrap1917)
               (vector 'syntax-object expression1918 wrap1917)))
            (syntax-object?251
             (lambda (x913)
               (if (vector? x913)
                   (if (= (vector-length x913) '3)
                       (eq? (vector-ref x913 '0) 'syntax-object)
                       '#f)
                   '#f)))
            (syntax-object-expression252
             (lambda (x1916) (vector-ref x1916 '1)))
            (syntax-object-wrap253 (lambda (x914) (vector-ref x914 '2)))
            (set-syntax-object-expression!254
             (lambda (x1915 update1914)
               (vector-set! x1915 '1 update1914)))
            (set-syntax-object-wrap!255
             (lambda (x916 update915) (vector-set! x916 '2 update915)))
            (source-annotation270
             (lambda (x1913)
               (if (annotation?126 x1913)
                   (annotation-source x1913)
                   (if (syntax-object?251 x1913)
                       (source-annotation270
                         (syntax-object-expression252 x1913))
                       '#f))))
            (make-binding278 (lambda (x918 y917) (cons x918 y917)))
            (binding-type279 car)
            (binding-value280 cdr)
            (set-binding-type!281 set-car!)
            (set-binding-value!282 set-cdr!)
            (binding?283
             (lambda (x1912)
               (if (pair? x1912) (symbol? (car x1912)) '#f)))
            (extend-env293
             (lambda (label921 binding919 r920)
               (cons (cons label921 binding919) r920)))
            (extend-env*294
             (lambda (labels1911 bindings1909 r1910)
               (if (null? labels1911)
                   r1910
                   (extend-env*294
                     (cdr labels1911)
                     (cdr bindings1909)
                     (extend-env293
                       (car labels1911)
                       (car bindings1909)
                       r1910)))))
            (extend-var-env*295
             (lambda (labels924 vars922 r923)
               (if (null? labels924)
                   r923
                   (extend-var-env*295
                     (cdr labels924)
                     (cdr vars922)
                     (extend-env293
                       (car labels924)
                       (make-binding278 'lexical (car vars922))
                       r923)))))
            (transformer-env296
             (lambda (r1907)
               (if (null? r1907)
                   '()
                   ((lambda (a1908)
                      (if (eq? (cadr a1908) 'lexical)
                          (transformer-env296 (cdr r1907))
                          (cons a1908 (transformer-env296 (cdr r1907)))))
                    (car r1907)))))
            (displaced-lexical-error297
             (lambda (id925)
               (syntax-error
                 id925
                 (if (id-var-name396 id925 '(()))
                     '"identifier out of context"
                     '"identifier not visible"))))
            (lookup*298
             (lambda (x1904 r1903)
               ((lambda (t1905)
                  (if t1905
                      (cdr t1905)
                      (if (symbol? x1904)
                          ((lambda (t1906)
                             (if t1906
                                 t1906
                                 (make-binding278 'global x1904)))
                           (get-global-definition-hook135 x1904))
                          (make-binding278 'displaced-lexical '#f))))
                (assq x1904 r1903))))
            (sanitize-binding299
             (lambda (b926)
               (if (procedure? b926)
                   (make-binding278 'macro b926)
                   (if (binding?283 b926)
                       ((lambda (t927)
                          (if (memv t927 '(core macro macro!))
                              (if (procedure? (binding-value280 b926))
                                  b926
                                  '#f)
                              (if (memv t927 '(module))
                                  (if (interface?414
                                        (binding-value280 b926))
                                      b926
                                      '#f)
                                  b926)))
                        (binding-type279 b926))
                       '#f))))
            (lookup300
             (lambda (x1894 r1893)
               (letrec ((whack-binding!1895
                         (lambda (b1902 *b1901)
                           (begin (set-binding-type!281
                                    b1902
                                    (binding-type279 *b1901))
                                  (set-binding-value!282
                                    b1902
                                    (binding-value280 *b1901))))))
                 ((lambda (b1896)
                    ((lambda (t1897)
                       (if (memv t1897 '(deferred))
                           (begin (whack-binding!1895
                                    b1896
                                    ((lambda (*b1898)
                                       ((lambda (t1899)
                                          (if t1899
                                              t1899
                                              (syntax-error
                                                *b1898
                                                '"invalid transformer")))
                                        (sanitize-binding299 *b1898)))
                                     (local-eval-hook128
                                       (binding-value280 b1896))))
                                  ((lambda (t1900) b1896)
                                   (binding-type279 b1896)))
                           b1896))
                     (binding-type279 b1896)))
                  (lookup*298 x1894 r1893)))))
            (global-extend301
             (lambda (type930 sym928 val929)
               (put-global-definition-hook134
                 sym928
                 (make-binding278 type930 val929))))
            (nonsymbol-id?302
             (lambda (x1891)
               (if (syntax-object?251 x1891)
                   (symbol?
                     ((lambda (e1892)
                        (if (annotation?126 e1892)
                            (annotation-expression e1892)
                            e1892))
                      (syntax-object-expression252 x1891)))
                   '#f)))
            (id?303
             (lambda (x931)
               (if (symbol? x931)
                   '#t
                   (if (syntax-object?251 x931)
                       (symbol?
                         ((lambda (e932)
                            (if (annotation?126 e932)
                                (annotation-expression e932)
                                e932))
                          (syntax-object-expression252 x931)))
                       (if (annotation?126 x931)
                           (symbol? (annotation-expression x931))
                           '#f)))))
            (id-sym-name&marks309
             (lambda (x1888 w1887)
               (if (syntax-object?251 x1888)
                   (values
                     ((lambda (e1889)
                        (if (annotation?126 e1889)
                            (annotation-expression e1889)
                            e1889))
                      (syntax-object-expression252 x1888))
                     (join-marks391
                       (wrap-marks311 w1887)
                       (wrap-marks311 (syntax-object-wrap253 x1888))))
                   (values
                     ((lambda (e1890)
                        (if (annotation?126 e1890)
                            (annotation-expression e1890)
                            e1890))
                      x1888)
                     (wrap-marks311 w1887)))))
            (make-wrap310 cons)
            (wrap-marks311 car)
            (wrap-subst312 cdr)
            (set-indirect-label!347
             (lambda (x1886 v1885)
               (set-indirect-label-label!344 x1886 v1885)))
            (get-indirect-label346
             (lambda (x933) (indirect-label-label343 x933)))
            (gen-indirect-label345
             (lambda () (make-indirect-label341 (gen-label348))))
            (set-indirect-label-label!344
             (lambda (x935 update934) (vector-set! x935 '1 update934)))
            (indirect-label-label343
             (lambda (x1884) (vector-ref x1884 '1)))
            (indirect-label?342
             (lambda (x936)
               (if (vector? x936)
                   (if (= (vector-length x936) '2)
                       (eq? (vector-ref x936 '0) 'indirect-label)
                       '#f)
                   '#f)))
            (make-indirect-label341
             (lambda (label1883) (vector 'indirect-label label1883)))
            (gen-label348 (lambda () (string '#\i)))
            (label?349
             (lambda (x1880)
               ((lambda (t1881)
                  (if t1881
                      t1881
                      ((lambda (t1882)
                         (if t1882 t1882 (indirect-label?342 x1880)))
                       (symbol? x1880))))
                (string? x1880))))
            (gen-labels350
             (lambda (ls937)
               (if (null? ls937)
                   '()
                   (cons (gen-label348) (gen-labels350 (cdr ls937))))))
            (make-ribcage351
             (lambda (symnames1879 marks1877 labels1878)
               (vector 'ribcage symnames1879 marks1877 labels1878)))
            (ribcage?352
             (lambda (x938)
               (if (vector? x938)
                   (if (= (vector-length x938) '4)
                       (eq? (vector-ref x938 '0) 'ribcage)
                       '#f)
                   '#f)))
            (ribcage-symnames353 (lambda (x1876) (vector-ref x1876 '1)))
            (ribcage-marks354 (lambda (x939) (vector-ref x939 '2)))
            (ribcage-labels355 (lambda (x1875) (vector-ref x1875 '3)))
            (set-ribcage-symnames!356
             (lambda (x941 update940) (vector-set! x941 '1 update940)))
            (set-ribcage-marks!357
             (lambda (x1874 update1873)
               (vector-set! x1874 '2 update1873)))
            (set-ribcage-labels!358
             (lambda (x943 update942) (vector-set! x943 '3 update942)))
            (anti-mark368
             (lambda (w1872)
               (make-wrap310
                 (cons '#f (wrap-marks311 w1872))
                 (cons 'shift (wrap-subst312 w1872)))))
            (barrier-marker373 '#f)
            (make-import-token374
             (lambda (key1871) (vector 'import-token key1871)))
            (import-token?375
             (lambda (x944)
               (if (vector? x944)
                   (if (= (vector-length x944) '2)
                       (eq? (vector-ref x944 '0) 'import-token)
                       '#f)
                   '#f)))
            (import-token-key376 (lambda (x1870) (vector-ref x1870 '1)))
            (set-import-token-key!377
             (lambda (x946 update945) (vector-set! x946 '1 update945)))
            (extend-ribcage!382
             (lambda (ribcage1868 id1866 label1867)
               (begin (set-ribcage-symnames!356
                        ribcage1868
                        (cons ((lambda (e1869)
                                 (if (annotation?126 e1869)
                                     (annotation-expression e1869)
                                     e1869))
                               (syntax-object-expression252 id1866))
                              (ribcage-symnames353 ribcage1868)))
                      (set-ribcage-marks!357
                        ribcage1868
                        (cons (wrap-marks311
                                (syntax-object-wrap253 id1866))
                              (ribcage-marks354 ribcage1868)))
                      (set-ribcage-labels!358
                        ribcage1868
                        (cons label1867
                              (ribcage-labels355 ribcage1868))))))
            (extend-ribcage-barrier!383
             (lambda (ribcage948 killer-id947)
               (extend-ribcage-barrier-help!384
                 ribcage948
                 (syntax-object-wrap253 killer-id947))))
            (extend-ribcage-barrier-help!384
             (lambda (ribcage1865 wrap1864)
               (begin (set-ribcage-symnames!356
                        ribcage1865
                        (cons barrier-marker373
                              (ribcage-symnames353 ribcage1865)))
                      (set-ribcage-marks!357
                        ribcage1865
                        (cons (wrap-marks311 wrap1864)
                              (ribcage-marks354 ribcage1865))))))
            (extend-ribcage-subst!385
             (lambda (ribcage950 token949)
               (set-ribcage-symnames!356
                 ribcage950
                 (cons (make-import-token374 token949)
                       (ribcage-symnames353 ribcage950)))))
            (lookup-import-binding-name386
             (lambda (sym1859 key1857 marks1858)
               ((lambda (new1860)
                  (if new1860
                      ((letrec ((f1861
                                 (lambda (new1862)
                                   (if (pair? new1862)
                                       ((lambda (t1863)
                                          (if t1863
                                              t1863
                                              (f1861 (cdr new1862))))
                                        (f1861 (car new1862)))
                                       (if (symbol? new1862)
                                           (if (same-marks?392
                                                 marks1858
                                                 (wrap-marks311 '((top))))
                                               new1862
                                               '#f)
                                           (if (same-marks?392
                                                 marks1858
                                                 (wrap-marks311
                                                   (syntax-object-wrap253
                                                     new1862)))
                                               new1862
                                               '#f))))))
                         f1861)
                       new1860)
                      '#f))
                (get-import-binding136 sym1859 key1857))))
            (make-binding-wrap387
             (lambda (ids953 labels951 w952)
               (if (null? ids953)
                   w952
                   (make-wrap310
                     (wrap-marks311 w952)
                     (cons ((lambda (labelvec954)
                              ((lambda (n955)
                                 ((lambda (symnamevec957 marksvec956)
                                    (begin ((letrec ((f958
                                                      (lambda (ids960 i959)
                                                        (if (not (null?
                                                                   ids960))
                                                            (call-with-values
                                                              (lambda ()
                                                                (id-sym-name&marks309
                                                                  (car ids960)
                                                                  w952))
                                                              (lambda (symname962
                                                                       marks961)
                                                                (begin (vector-set!
                                                                         symnamevec957
                                                                         i959
                                                                         symname962)
                                                                       (vector-set!
                                                                         marksvec956
                                                                         i959
                                                                         marks961)
                                                                       (f958 (cdr ids960)
                                                                             (+ i959
                                                                                '1)))))
                                                            (void)))))
                                              f958)
                                            ids953
                                            '0)
                                           (make-ribcage351
                                             symnamevec957
                                             marksvec956
                                             labelvec954)))
                                  (make-vector n955)
                                  (make-vector n955)))
                               (vector-length labelvec954)))
                            (list->vector labels951))
                           (wrap-subst312 w952))))))
            (make-trimmed-syntax-object388
             (lambda (id1851)
               (call-with-values
                 (lambda () (id-var-name&marks394 id1851 '(())))
                 (lambda (tosym1853 marks1852)
                   (begin (if (not tosym1853)
                              (syntax-error
                                id1851
                                '"identifier not visible for export")
                              (void))
                          ((lambda (fromsym1854)
                             (make-syntax-object250
                               fromsym1854
                               (make-wrap310
                                 marks1852
                                 (list (make-ribcage351
                                         (vector fromsym1854)
                                         (vector marks1852)
                                         (vector tosym1853))))))
                           ((lambda (x1855)
                              ((lambda (e1856)
                                 (if (annotation?126 e1856)
                                     (annotation-expression e1856)
                                     e1856))
                               (if (syntax-object?251 x1855)
                                   (syntax-object-expression252 x1855)
                                   x1855)))
                            id1851)))))))
            (smart-append389
             (lambda (m1964 m2963)
               (if (null? m2963) m1964 (append m1964 m2963))))
            (join-wraps390
             (lambda (w11848 w21847)
               ((lambda (m11850 s11849)
                  (if (null? m11850)
                      (if (null? s11849)
                          w21847
                          (make-wrap310
                            (wrap-marks311 w21847)
                            (smart-append389
                              s11849
                              (wrap-subst312 w21847))))
                      (make-wrap310
                        (smart-append389 m11850 (wrap-marks311 w21847))
                        (smart-append389 s11849 (wrap-subst312 w21847)))))
                (wrap-marks311 w11848)
                (wrap-subst312 w11848))))
            (join-marks391
             (lambda (m1966 m2965) (smart-append389 m1966 m2965)))
            (same-marks?392
             (lambda (x1845 y1844)
               ((lambda (t1846)
                  (if t1846
                      t1846
                      (if (not (null? x1845))
                          (if (not (null? y1844))
                              (if (eq? (car x1845) (car y1844))
                                  (same-marks?392 (cdr x1845) (cdr y1844))
                                  '#f)
                              '#f)
                          '#f)))
                (eq? x1845 y1844))))
            (id-var-name-loc&marks393
             (lambda (id968 w967)
               (letrec ((search969
                         (lambda (sym999 subst997 marks998)
                           (if (null? subst997)
                               (values sym999 marks998)
                               ((lambda (fst1000)
                                  (if (eq? fst1000 'shift)
                                      (search969
                                        sym999
                                        (cdr subst997)
                                        (cdr marks998))
                                      ((lambda (symnames1001)
                                         (if (vector? symnames1001)
                                             (search-vector-rib971
                                               sym999
                                               subst997
                                               marks998
                                               symnames1001
                                               fst1000)
                                             (search-list-rib970
                                               sym999
                                               subst997
                                               marks998
                                               symnames1001
                                               fst1000)))
                                       (ribcage-symnames353 fst1000))))
                                (car subst997)))))
                        (search-list-rib970
                         (lambda (sym983
                                  subst979
                                  marks982
                                  symnames980
                                  ribcage981)
                           ((letrec ((f984
                                      (lambda (symnames986 i985)
                                        (if (null? symnames986)
                                            (search969
                                              sym983
                                              (cdr subst979)
                                              marks982)
                                            (if (if (eq? (car symnames986)
                                                         sym983)
                                                    (same-marks?392
                                                      marks982
                                                      (list-ref
                                                        (ribcage-marks354
                                                          ribcage981)
                                                        i985))
                                                    '#f)
                                                (values
                                                  (list-ref
                                                    (ribcage-labels355
                                                      ribcage981)
                                                    i985)
                                                  marks982)
                                                (if (import-token?375
                                                      (car symnames986))
                                                    ((lambda (t987)
                                                       (if t987
                                                           ((lambda (id988)
                                                              (if (symbol?
                                                                    id988)
                                                                  (values
                                                                    id988
                                                                    marks982)
                                                                  (id-var-name&marks394
                                                                    id988
                                                                    '(()))))
                                                            t987)
                                                           (f984 (cdr symnames986)
                                                                 i985)))
                                                     (lookup-import-binding-name386
                                                       sym983
                                                       (import-token-key376
                                                         (car symnames986))
                                                       marks982))
                                                    (if (if (eq? (car symnames986)
                                                                 barrier-marker373)
                                                            (same-marks?392
                                                              marks982
                                                              (list-ref
                                                                (ribcage-marks354
                                                                  ribcage981)
                                                                i985))
                                                            '#f)
                                                        (values
                                                          '#f
                                                          marks982)
                                                        (f984 (cdr symnames986)
                                                              (+ i985
                                                                 '1)))))))))
                              f984)
                            symnames980
                            '0)))
                        (search-vector-rib971
                         (lambda (sym993
                                  subst989
                                  marks992
                                  symnames990
                                  ribcage991)
                           ((lambda (n994)
                              ((letrec ((f995
                                         (lambda (i996)
                                           (if (= i996 n994)
                                               (search969
                                                 sym993
                                                 (cdr subst989)
                                                 marks992)
                                               (if (if (eq? (vector-ref
                                                              symnames990
                                                              i996)
                                                            sym993)
                                                       (same-marks?392
                                                         marks992
                                                         (vector-ref
                                                           (ribcage-marks354
                                                             ribcage991)
                                                           i996))
                                                       '#f)
                                                   (values
                                                     (vector-ref
                                                       (ribcage-labels355
                                                         ribcage991)
                                                       i996)
                                                     marks992)
                                                   (f995 (+ i996 '1)))))))
                                 f995)
                               '0))
                            (vector-length symnames990)))))
                 (if (symbol? id968)
                     (search969
                       id968
                       (wrap-subst312 w967)
                       (wrap-marks311 w967))
                     (if (syntax-object?251 id968)
                         ((lambda (sym973 w1972)
                            ((lambda (marks974)
                               (call-with-values
                                 (lambda ()
                                   (search969
                                     sym973
                                     (wrap-subst312 w967)
                                     marks974))
                                 (lambda (new-id976 marks975)
                                   (if (eq? new-id976 sym973)
                                       (search969
                                         sym973
                                         (wrap-subst312 w1972)
                                         marks975)
                                       (values new-id976 marks975)))))
                             (join-marks391
                               (wrap-marks311 w967)
                               (wrap-marks311 w1972))))
                          ((lambda (e977)
                             (if (annotation?126 e977)
                                 (annotation-expression e977)
                                 e977))
                           (syntax-object-expression252 id968))
                          (syntax-object-wrap253 id968))
                         (if (annotation?126 id968)
                             (search969
                               ((lambda (e978)
                                  (if (annotation?126 e978)
                                      (annotation-expression e978)
                                      e978))
                                id968)
                               (wrap-subst312 w967)
                               (wrap-marks311 w967))
                             (error-hook129
                               'id-var-name
                               '"invalid id"
                               id968)))))))
            (id-var-name&marks394
             (lambda (id1841 w1840)
               (call-with-values
                 (lambda () (id-var-name-loc&marks393 id1841 w1840))
                 (lambda (label1843 marks1842)
                   (values
                     (if (indirect-label?342 label1843)
                         (get-indirect-label346 label1843)
                         label1843)
                     marks1842)))))
            (id-var-name-loc395
             (lambda (id1003 w1002)
               (call-with-values
                 (lambda () (id-var-name-loc&marks393 id1003 w1002))
                 (lambda (label1005 marks1004) label1005))))
            (id-var-name396
             (lambda (id1837 w1836)
               (call-with-values
                 (lambda () (id-var-name-loc&marks393 id1837 w1836))
                 (lambda (label1839 marks1838)
                   (if (indirect-label?342 label1839)
                       (get-indirect-label346 label1839)
                       label1839)))))
            (free-id=?397
             (lambda (i1007 j1006)
               (if (eq? ((lambda (x1010)
                           ((lambda (e1011)
                              (if (annotation?126 e1011)
                                  (annotation-expression e1011)
                                  e1011))
                            (if (syntax-object?251 x1010)
                                (syntax-object-expression252 x1010)
                                x1010)))
                         i1007)
                        ((lambda (x1008)
                           ((lambda (e1009)
                              (if (annotation?126 e1009)
                                  (annotation-expression e1009)
                                  e1009))
                            (if (syntax-object?251 x1008)
                                (syntax-object-expression252 x1008)
                                x1008)))
                         j1006))
                   (eq? (id-var-name396 i1007 '(()))
                        (id-var-name396 j1006 '(())))
                   '#f)))
            (literal-id=?398
             (lambda (id1826 literal1825)
               (if (eq? ((lambda (x1829)
                           ((lambda (e1830)
                              (if (annotation?126 e1830)
                                  (annotation-expression e1830)
                                  e1830))
                            (if (syntax-object?251 x1829)
                                (syntax-object-expression252 x1829)
                                x1829)))
                         id1826)
                        ((lambda (x1827)
                           ((lambda (e1828)
                              (if (annotation?126 e1828)
                                  (annotation-expression e1828)
                                  e1828))
                            (if (syntax-object?251 x1827)
                                (syntax-object-expression252 x1827)
                                x1827)))
                         literal1825))
                   ((lambda (n-id1832 n-literal1831)
                      ((lambda (t1833)
                         (if t1833
                             t1833
                             (if ((lambda (t1834)
                                    (if t1834 t1834 (symbol? n-id1832)))
                                  (not n-id1832))
                                 ((lambda (t1835)
                                    (if t1835
                                        t1835
                                        (symbol? n-literal1831)))
                                  (not n-literal1831))
                                 '#f)))
                       (eq? n-id1832 n-literal1831)))
                    (id-var-name396 id1826 '(()))
                    (id-var-name396 literal1825 '(())))
                   '#f)))
            (bound-id=?399
             (lambda (i1013 j1012)
               (if (if (syntax-object?251 i1013)
                       (syntax-object?251 j1012)
                       '#f)
                   (if (eq? ((lambda (e1015)
                               (if (annotation?126 e1015)
                                   (annotation-expression e1015)
                                   e1015))
                             (syntax-object-expression252 i1013))
                            ((lambda (e1014)
                               (if (annotation?126 e1014)
                                   (annotation-expression e1014)
                                   e1014))
                             (syntax-object-expression252 j1012)))
                       (same-marks?392
                         (wrap-marks311 (syntax-object-wrap253 i1013))
                         (wrap-marks311 (syntax-object-wrap253 j1012)))
                       '#f)
                   (eq? ((lambda (e1017)
                           (if (annotation?126 e1017)
                               (annotation-expression e1017)
                               e1017))
                         i1013)
                        ((lambda (e1016)
                           (if (annotation?126 e1016)
                               (annotation-expression e1016)
                               e1016))
                         j1012)))))
            (valid-bound-ids?400
             (lambda (ids1821)
               (if ((letrec ((all-ids?1822
                              (lambda (ids1823)
                                ((lambda (t1824)
                                   (if t1824
                                       t1824
                                       (if (id?303 (car ids1823))
                                           (all-ids?1822 (cdr ids1823))
                                           '#f)))
                                 (null? ids1823)))))
                      all-ids?1822)
                    ids1821)
                   (distinct-bound-ids?401 ids1821)
                   '#f)))
            (distinct-bound-ids?401
             (lambda (ids1018)
               ((letrec ((distinct?1019
                          (lambda (ids1020)
                            ((lambda (t1021)
                               (if t1021
                                   t1021
                                   (if (not (bound-id-member?403
                                              (car ids1020)
                                              (cdr ids1020)))
                                       (distinct?1019 (cdr ids1020))
                                       '#f)))
                             (null? ids1020)))))
                  distinct?1019)
                ids1018)))
            (invalid-ids-error402
             (lambda (ids1817 exp1815 class1816)
               ((letrec ((find1818
                          (lambda (ids1820 gooduns1819)
                            (if (null? ids1820)
                                (syntax-error exp1815)
                                (if (id?303 (car ids1820))
                                    (if (bound-id-member?403
                                          (car ids1820)
                                          gooduns1819)
                                        (syntax-error
                                          (car ids1820)
                                          '"duplicate "
                                          class1816)
                                        (find1818
                                          (cdr ids1820)
                                          (cons (car ids1820)
                                                gooduns1819)))
                                    (syntax-error
                                      (car ids1820)
                                      '"invalid "
                                      class1816))))))
                  find1818)
                ids1817
                '())))
            (bound-id-member?403
             (lambda (x1023 list1022)
               (if (not (null? list1022))
                   ((lambda (t1024)
                      (if t1024
                          t1024
                          (bound-id-member?403 x1023 (cdr list1022))))
                    (bound-id=?399 x1023 (car list1022)))
                   '#f)))
            (wrap404
             (lambda (x1814 w1813)
               (if (if (null? (wrap-marks311 w1813))
                       (null? (wrap-subst312 w1813))
                       '#f)
                   x1814
                   (if (syntax-object?251 x1814)
                       (make-syntax-object250
                         (syntax-object-expression252 x1814)
                         (join-wraps390
                           w1813
                           (syntax-object-wrap253 x1814)))
                       (if (null? x1814)
                           x1814
                           (make-syntax-object250 x1814 w1813))))))
            (source-wrap405
             (lambda (x1027 w1025 s1026)
               (wrap404
                 (if s1026 (make-annotation x1027 s1026 '#f) x1027)
                 w1025)))
            (chi-sequence406
             (lambda (body1807 r1804 w1806 s1805)
               (build-sequence236
                 s1805
                 ((letrec ((dobody1808
                            (lambda (body1811 r1809 w1810)
                              (if (null? body1811)
                                  '()
                                  ((lambda (first1812)
                                     (cons first1812
                                           (dobody1808
                                             (cdr body1811)
                                             r1809
                                             w1810)))
                                   (chi446 (car body1811) r1809 w1810))))))
                    dobody1808)
                  body1807
                  r1804
                  w1806))))
            (chi-top-sequence407
             (lambda (body1034
                      r1028
                      w1033
                      s1029
                      ctem1032
                      rtem1030
                      ribcage1031)
               (build-sequence236
                 s1029
                 ((letrec ((dobody1035
                            (lambda (body1040
                                     r1036
                                     w1039
                                     ctem1037
                                     rtem1038)
                              (if (null? body1040)
                                  '()
                                  ((lambda (first1041)
                                     (cons first1041
                                           (dobody1035
                                             (cdr body1040)
                                             r1036
                                             w1039
                                             ctem1037
                                             rtem1038)))
                                   (chi-top411
                                     (car body1040)
                                     r1036
                                     w1039
                                     ctem1037
                                     rtem1038
                                     ribcage1031))))))
                    dobody1035)
                  body1034
                  r1028
                  w1033
                  ctem1032
                  rtem1030))))
            (chi-when-list408
             (lambda (when-list1802 w1801)
               (map (lambda (x1803)
                      (if (literal-id=?398
                            x1803
                            '#(syntax-object compile ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks same-marks? join-marks join-wraps smart-append make-trimmed-syntax-object make-binding-wrap lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage set-import-token-key! import-token-key import-token? make-import-token barrier-marker new-mark anti-mark the-anti-mark set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend lookup sanitize-binding lookup* displaced-lexical-error transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check source-annotation no-source unannotate set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id get-import-binding get-global-definition-hook put-global-definition-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()) #(ribcage (#(import-token *top*)) () ()))))
                          'compile
                          (if (literal-id=?398
                                x1803
                                '#(syntax-object load ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks same-marks? join-marks join-wraps smart-append make-trimmed-syntax-object make-binding-wrap lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage set-import-token-key! import-token-key import-token? make-import-token barrier-marker new-mark anti-mark the-anti-mark set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend lookup sanitize-binding lookup* displaced-lexical-error transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check source-annotation no-source unannotate set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id get-import-binding get-global-definition-hook put-global-definition-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()) #(ribcage (#(import-token *top*)) () ()))))
                              'load
                              (if (literal-id=?398
                                    x1803
                                    '#(syntax-object visit ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks same-marks? join-marks join-wraps smart-append make-trimmed-syntax-object make-binding-wrap lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage set-import-token-key! import-token-key import-token? make-import-token barrier-marker new-mark anti-mark the-anti-mark set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend lookup sanitize-binding lookup* displaced-lexical-error transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check source-annotation no-source unannotate set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id get-import-binding get-global-definition-hook put-global-definition-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()) #(ribcage (#(import-token *top*)) () ()))))
                                  'visit
                                  (if (literal-id=?398
                                        x1803
                                        '#(syntax-object revisit ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks same-marks? join-marks join-wraps smart-append make-trimmed-syntax-object make-binding-wrap lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage set-import-token-key! import-token-key import-token? make-import-token barrier-marker new-mark anti-mark the-anti-mark set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend lookup sanitize-binding lookup* displaced-lexical-error transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check source-annotation no-source unannotate set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id get-import-binding get-global-definition-hook put-global-definition-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()) #(ribcage (#(import-token *top*)) () ()))))
                                      'revisit
                                      (if (literal-id=?398
                                            x1803
                                            '#(syntax-object eval ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(when-list w) #((top) (top)) #("i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks same-marks? join-marks join-wraps smart-append make-trimmed-syntax-object make-binding-wrap lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage set-import-token-key! import-token-key import-token? make-import-token barrier-marker new-mark anti-mark the-anti-mark set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend lookup sanitize-binding lookup* displaced-lexical-error transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check source-annotation no-source unannotate set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id get-import-binding get-global-definition-hook put-global-definition-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()) #(ribcage (#(import-token *top*)) () ()))))
                                          'eval
                                          (syntax-error
                                            (wrap404 x1803 w1801)
                                            '"invalid eval-when situation")))))))
                    when-list1802)))
            (syntax-type409
             (lambda (e1046 r1042 w1045 s1043 rib1044)
               (if (symbol? e1046)
                   ((lambda (n1047)
                      ((lambda (b1048)
                         ((lambda (type1049)
                            ((lambda ()
                               ((lambda (t1050)
                                  (if (memv t1050 '(lexical))
                                      (values
                                        type1049
                                        (binding-value280 b1048)
                                        e1046
                                        w1045
                                        s1043)
                                      (if (memv t1050 '(global))
                                          (values
                                            type1049
                                            (binding-value280 b1048)
                                            e1046
                                            w1045
                                            s1043)
                                          (if (memv t1050 '(macro macro!))
                                              (syntax-type409
                                                (chi-macro450
                                                  (binding-value280 b1048)
                                                  e1046
                                                  r1042
                                                  w1045
                                                  s1043
                                                  rib1044)
                                                r1042
                                                '(())
                                                '#f
                                                rib1044)
                                              (values
                                                type1049
                                                (binding-value280 b1048)
                                                e1046
                                                w1045
                                                s1043)))))
                                type1049))))
                          (binding-type279 b1048)))
                       (lookup300 n1047 r1042)))
                    (id-var-name396 e1046 w1045))
                   (if (pair? e1046)
                       ((lambda (first1051)
                          (if (id?303 first1051)
                              ((lambda (n1052)
                                 ((lambda (b1053)
                                    ((lambda (type1054)
                                       ((lambda ()
                                          ((lambda (t1055)
                                             (if (memv t1055 '(lexical))
                                                 (values
                                                   'lexical-call
                                                   (binding-value280 b1053)
                                                   e1046
                                                   w1045
                                                   s1043)
                                                 (if (memv t1055
                                                           '(macro macro!))
                                                     (syntax-type409
                                                       (chi-macro450
                                                         (binding-value280
                                                           b1053)
                                                         e1046
                                                         r1042
                                                         w1045
                                                         s1043
                                                         rib1044)
                                                       r1042
                                                       '(())
                                                       '#f
                                                       rib1044)
                                                     (if (memv t1055
                                                               '(core))
                                                         (values
                                                           type1054
                                                           (binding-value280
                                                             b1053)
                                                           e1046
                                                           w1045
                                                           s1043)
                                                         (if (memv t1055
                                                                   '(local-syntax))
                                                             (values
                                                               'local-syntax-form
                                                               (binding-value280
                                                                 b1053)
                                                               e1046
                                                               w1045
                                                               s1043)
                                                             (if (memv t1055
                                                                       '(begin))
                                                                 (values
                                                                   'begin-form
                                                                   '#f
                                                                   e1046
                                                                   w1045
                                                                   s1043)
                                                                 (if (memv t1055
                                                                           '(eval-when))
                                                                     (values
                                                                       'eval-when-form
                                                                       '#f
                                                                       e1046
                                                                       w1045
                                                                       s1043)
                                                                     (if (memv t1055
                                                                               '(define))
                                                                         (values
                                                                           'define-form
                                                                           '#f
                                                                           e1046
                                                                           w1045
                                                                           s1043)
                                                                         (if (memv t1055
                                                                                   '(define-syntax))
                                                                             (values
                                                                               'define-syntax-form
                                                                               '#f
                                                                               e1046
                                                                               w1045
                                                                               s1043)
                                                                             (if (memv t1055
                                                                                       '(module-key))
                                                                                 (values
                                                                                   'module-form
                                                                                   '#f
                                                                                   e1046
                                                                                   w1045
                                                                                   s1043)
                                                                                 (if (memv t1055
                                                                                           '(import))
                                                                                     (values
                                                                                       'import-form
                                                                                       (if (binding-value280
                                                                                             b1053)
                                                                                           (wrap404
                                                                                             first1051
                                                                                             w1045)
                                                                                           '#f)
                                                                                       e1046
                                                                                       w1045
                                                                                       s1043)
                                                                                     (if (memv t1055
                                                                                               '(set!))
                                                                                         (chi-set!449
                                                                                           e1046
                                                                                           r1042
                                                                                           w1045
                                                                                           s1043
                                                                                           rib1044)
                                                                                         (values
                                                                                           'call
                                                                                           '#f
                                                                                           e1046
                                                                                           w1045
                                                                                           s1043)))))))))))))
                                           type1054))))
                                     (binding-type279 b1053)))
                                  (lookup300 n1052 r1042)))
                               (id-var-name396 first1051 w1045))
                              (values 'call '#f e1046 w1045 s1043)))
                        (car e1046))
                       (if (syntax-object?251 e1046)
                           (syntax-type409
                             (syntax-object-expression252 e1046)
                             r1042
                             (join-wraps390
                               w1045
                               (syntax-object-wrap253 e1046))
                             '#f
                             rib1044)
                           (if (annotation?126 e1046)
                               (syntax-type409
                                 (annotation-expression e1046)
                                 r1042
                                 w1045
                                 (annotation-source e1046)
                                 rib1044)
                               (if ((lambda (x1056)
                                      ((lambda (t1057)
                                         (if t1057
                                             t1057
                                             ((lambda (t1058)
                                                (if t1058
                                                    t1058
                                                    ((lambda (t1059)
                                                       (if t1059
                                                           t1059
                                                           ((lambda (t1060)
                                                              (if t1060
                                                                  t1060
                                                                  (null?
                                                                    x1056)))
                                                            (char?
                                                              x1056))))
                                                     (string? x1056))))
                                              (number? x1056))))
                                       (boolean? x1056)))
                                    e1046)
                                   (values 'constant '#f e1046 w1045 s1043)
                                   (values
                                     'other
                                     '#f
                                     e1046
                                     w1045
                                     s1043))))))))
            (chi-top-expr410
             (lambda (e1795 r1792 w1794 top-ribcage1793)
               (call-with-values
                 (lambda ()
                   (syntax-type409 e1795 r1792 w1794 '#f top-ribcage1793))
                 (lambda (type1800 value1796 e1799 w1797 s1798)
                   (chi-expr447
                     type1800
                     value1796
                     e1799
                     r1792
                     w1797
                     s1798)))))
            (chi-top411
             (lambda (e1066
                      r1061
                      w1065
                      ctem1062
                      rtem1064
                      top-ribcage1063)
               (call-with-values
                 (lambda ()
                   (syntax-type409 e1066 r1061 w1065 '#f top-ribcage1063))
                 (lambda (type1071 value1067 e1070 w1068 s1069)
                   ((lambda (t1072)
                      (if (memv t1072 '(begin-form))
                          ((lambda (tmp1073)
                             ((lambda (tmp1074)
                                (if tmp1074
                                    (apply
                                      (lambda (_1075) (chi-void460))
                                      tmp1074)
                                    ((lambda (tmp1076)
                                       (if tmp1076
                                           (apply
                                             (lambda (_1079 e11077 e21078)
                                               (chi-top-sequence407
                                                 (cons e11077 e21078)
                                                 r1061
                                                 w1068
                                                 s1069
                                                 ctem1062
                                                 rtem1064
                                                 top-ribcage1063))
                                             tmp1076)
                                           (syntax-error tmp1073)))
                                     ($syntax-dispatch
                                       tmp1073
                                       '(any any . each-any)))))
                              ($syntax-dispatch tmp1073 '(any))))
                           e1070)
                          (if (memv t1072 '(local-syntax-form))
                              (chi-local-syntax459
                                value1067
                                e1070
                                r1061
                                w1068
                                s1069
                                (lambda (body1084 r1081 w1083 s1082)
                                  (chi-top-sequence407
                                    body1084
                                    r1081
                                    w1083
                                    s1082
                                    ctem1062
                                    rtem1064
                                    top-ribcage1063)))
                              (if (memv t1072 '(eval-when-form))
                                  ((lambda (tmp1085)
                                     ((lambda (tmp1086)
                                        (if tmp1086
                                            (apply
                                              (lambda (_1090
                                                       x1087
                                                       e11089
                                                       e21088)
                                                ((lambda (when-list1092
                                                          body1091)
                                                   ((lambda (ctem1094
                                                             rtem1093)
                                                      (if (if (null?
                                                                ctem1094)
                                                              (null?
                                                                rtem1093)
                                                              '#f)
                                                          (chi-void460)
                                                          (chi-top-sequence407
                                                            body1091
                                                            r1061
                                                            w1068
                                                            s1069
                                                            ctem1094
                                                            rtem1093
                                                            top-ribcage1063)))
                                                    (update-mode-set442
                                                      when-list1092
                                                      ctem1062)
                                                    (update-mode-set442
                                                      when-list1092
                                                      rtem1064)))
                                                 (chi-when-list408
                                                   x1087
                                                   w1068)
                                                 (cons e11089 e21088)))
                                              tmp1086)
                                            (syntax-error tmp1085)))
                                      ($syntax-dispatch
                                        tmp1085
                                        '(any each-any any . each-any))))
                                   e1070)
                                  (if (memv t1072 '(define-syntax-form))
                                      (parse-define-syntax457
                                        e1070
                                        w1068
                                        s1069
                                        (lambda (id1099 rhs1097 w1098)
                                          ((lambda (id1100)
                                             (begin ((lambda (n1105)
                                                       ((lambda (b1106)
                                                          ((lambda (t1107)
                                                             (if (memv t1107
                                                                       '(displaced-lexical))
                                                                 (displaced-lexical-error297
                                                                   id1100)
                                                                 (void)))
                                                           (binding-type279
                                                             b1106)))
                                                        (lookup300
                                                          n1105
                                                          r1061)))
                                                     (id-var-name396
                                                       id1100
                                                       '(())))
                                                    (ct-eval/residualize445
                                                      ctem1062
                                                      (lambda ()
                                                        (list '$sc-put-cte
                                                              (list 'quote
                                                                    ((lambda (sym1101)
                                                                       (if (same-marks?392
                                                                             (wrap-marks311
                                                                               (syntax-object-wrap253
                                                                                 id1100))
                                                                             (wrap-marks311
                                                                               '((top))))
                                                                           sym1101
                                                                           ((lambda (marks1102)
                                                                              (make-syntax-object250
                                                                                sym1101
                                                                                (make-wrap310
                                                                                  marks1102
                                                                                  (list (make-ribcage351
                                                                                          (vector
                                                                                            sym1101)
                                                                                          (vector
                                                                                            marks1102)
                                                                                          (vector
                                                                                            (generate-id137
                                                                                              sym1101)))))))
                                                                            (wrap-marks311
                                                                              (syntax-object-wrap253
                                                                                id1100)))))
                                                                     ((lambda (x1103)
                                                                        ((lambda (e1104)
                                                                           (if (annotation?126
                                                                                 e1104)
                                                                               (annotation-expression
                                                                                 e1104)
                                                                               e1104))
                                                                         (if (syntax-object?251
                                                                               x1103)
                                                                             (syntax-object-expression252
                                                                               x1103)
                                                                             x1103)))
                                                                      id1100)))
                                                              (chi446
                                                                rhs1097
                                                                (transformer-env296
                                                                  r1061)
                                                                w1098))))))
                                           (wrap404 id1099 w1098))))
                                      (if (memv t1072 '(define-form))
                                          (parse-define456
                                            e1070
                                            w1068
                                            s1069
                                            (lambda (id1110 rhs1108 w1109)
                                              ((lambda (id1111)
                                                 (begin ((lambda (n1117)
                                                           ((lambda (b1118)
                                                              ((lambda (t1119)
                                                                 (if (memv t1119
                                                                           '(displaced-lexical))
                                                                     (displaced-lexical-error297
                                                                       id1111)
                                                                     (void)))
                                                               (binding-type279
                                                                 b1118)))
                                                            (lookup300
                                                              n1117
                                                              r1061)))
                                                         (id-var-name396
                                                           id1111
                                                           '(())))
                                                        ((lambda (sym1112)
                                                           ((lambda (valsym1113)
                                                              (build-sequence236
                                                                '#f
                                                                (list (ct-eval/residualize445
                                                                        ctem1062
                                                                        (lambda ()
                                                                          (list '$sc-put-cte
                                                                                (list 'quote
                                                                                      (if (eq? sym1112
                                                                                               valsym1113)
                                                                                          sym1112
                                                                                          ((lambda (marks1114)
                                                                                             (make-syntax-object250
                                                                                               sym1112
                                                                                               (make-wrap310
                                                                                                 marks1114
                                                                                                 (list (make-ribcage351
                                                                                                         (vector
                                                                                                           sym1112)
                                                                                                         (vector
                                                                                                           marks1114)
                                                                                                         (vector
                                                                                                           valsym1113))))))
                                                                                           (wrap-marks311
                                                                                             (syntax-object-wrap253
                                                                                               id1111)))))
                                                                                (list 'quote
                                                                                      (make-binding278
                                                                                        'global
                                                                                        valsym1113)))))
                                                                      (rt-eval/residualize444
                                                                        rtem1064
                                                                        (lambda ()
                                                                          (list 'define
                                                                                valsym1113
                                                                                (chi446
                                                                                  rhs1108
                                                                                  r1061
                                                                                  w1109)))))))
                                                            (if (same-marks?392
                                                                  (wrap-marks311
                                                                    (syntax-object-wrap253
                                                                      id1111))
                                                                  (wrap-marks311
                                                                    '((top))))
                                                                sym1112
                                                                (generate-id137
                                                                  sym1112))))
                                                         ((lambda (x1115)
                                                            ((lambda (e1116)
                                                               (if (annotation?126
                                                                     e1116)
                                                                   (annotation-expression
                                                                     e1116)
                                                                   e1116))
                                                             (if (syntax-object?251
                                                                   x1115)
                                                                 (syntax-object-expression252
                                                                   x1115)
                                                                 x1115)))
                                                          id1111))))
                                               (wrap404 id1110 w1109))))
                                          (if (memv t1072 '(module-form))
                                              ((lambda (r1121 ribcage1120)
                                                 (parse-module454
                                                   e1070
                                                   w1068
                                                   s1069
                                                   (make-wrap310
                                                     (wrap-marks311 w1068)
                                                     (cons ribcage1120
                                                           (wrap-subst312
                                                             w1068)))
                                                   (lambda (id1124
                                                            exports1122
                                                            forms1123)
                                                     (if id1124
                                                         (begin ((lambda (n1125)
                                                                   ((lambda (b1126)
                                                                      ((lambda (t1127)
                                                                         (if (memv t1127
                                                                                   '(displaced-lexical))
                                                                             (displaced-lexical-error297
                                                                               (wrap404
                                                                                 id1124
                                                                                 w1068))
                                                                             (void)))
                                                                       (binding-type279
                                                                         b1126)))
                                                                    (lookup300
                                                                      n1125
                                                                      r1121)))
                                                                 (id-var-name396
                                                                   id1124
                                                                   '(())))
                                                                (chi-top-module433
                                                                  e1070
                                                                  r1121
                                                                  ribcage1120
                                                                  w1068
                                                                  s1069
                                                                  ctem1062
                                                                  rtem1064
                                                                  id1124
                                                                  exports1122
                                                                  forms1123))
                                                         (chi-top-module433
                                                           e1070
                                                           r1121
                                                           ribcage1120
                                                           w1068
                                                           s1069
                                                           ctem1062
                                                           rtem1064
                                                           '#f
                                                           exports1122
                                                           forms1123)))))
                                               (cons '("top-level module placeholder"
                                                        placeholder)
                                                     r1061)
                                               (make-ribcage351
                                                 '()
                                                 '()
                                                 '()))
                                              (if (memv t1072
                                                        '(import-form))
                                                  (parse-import455
                                                    e1070
                                                    w1068
                                                    s1069
                                                    (lambda (mid1128)
                                                      (ct-eval/residualize445
                                                        ctem1062
                                                        (lambda ()
                                                          (begin (if value1067
                                                                     (syntax-error
                                                                       (source-wrap405
                                                                         e1070
                                                                         w1068
                                                                         s1069)
                                                                       '"not valid at top-level")
                                                                     (void))
                                                                 ((lambda (binding1129)
                                                                    ((lambda (t1130)
                                                                       (if (memv t1130
                                                                                 '(module))
                                                                           (do-top-import441
                                                                             mid1128
                                                                             (interface-token416
                                                                               (binding-value280
                                                                                 binding1129)))
                                                                           (if (memv t1130
                                                                                     '(displaced-lexical))
                                                                               (displaced-lexical-error297
                                                                                 mid1128)
                                                                               (syntax-error
                                                                                 mid1128
                                                                                 '"import from unknown module"))))
                                                                     (binding-type279
                                                                       binding1129)))
                                                                  (lookup300
                                                                    (id-var-name396
                                                                      mid1128
                                                                      '(()))
                                                                    '())))))))
                                                  (rt-eval/residualize444
                                                    rtem1064
                                                    (lambda ()
                                                      (chi-expr447
                                                        type1071
                                                        value1067
                                                        e1070
                                                        r1061
                                                        w1068
                                                        s1069)))))))))))
                    type1071)))))
            (flatten-exports412
             (lambda (exports1788)
               ((letrec ((loop1789
                          (lambda (exports1791 ls1790)
                            (if (null? exports1791)
                                ls1790
                                (loop1789
                                  (cdr exports1791)
                                  (if (pair? (car exports1791))
                                      (loop1789 (car exports1791) ls1790)
                                      (cons (car exports1791) ls1790)))))))
                  loop1789)
                exports1788
                '())))
            (make-interface413
             (lambda (exports1132 token1131)
               (vector 'interface exports1132 token1131)))
            (interface?414
             (lambda (x1787)
               (if (vector? x1787)
                   (if (= (vector-length x1787) '3)
                       (eq? (vector-ref x1787 '0) 'interface)
                       '#f)
                   '#f)))
            (interface-exports415
             (lambda (x1133) (vector-ref x1133 '1)))
            (interface-token416 (lambda (x1786) (vector-ref x1786 '2)))
            (set-interface-exports!417
             (lambda (x1135 update1134)
               (vector-set! x1135 '1 update1134)))
            (set-interface-token!418
             (lambda (x1785 update1784)
               (vector-set! x1785 '2 update1784)))
            (make-trimmed-interface419
             (lambda (exports1136)
               (make-interface413
                 (list->vector
                   (map (lambda (x1137)
                          (if (pair? x1137) (car x1137) x1137))
                        exports1136))
                 '#f)))
            (make-resolved-interface420
             (lambda (exports1782 import-token1781)
               (make-interface413
                 (list->vector
                   (map (lambda (x1783)
                          (make-trimmed-syntax-object388
                            (if (pair? x1783) (car x1783) x1783)))
                        exports1782))
                 import-token1781)))
            (make-module-binding421
             (lambda (type1142 id1138 label1141 imps1139 val1140)
               (vector
                 'module-binding
                 type1142
                 id1138
                 label1141
                 imps1139
                 val1140)))
            (module-binding?422
             (lambda (x1780)
               (if (vector? x1780)
                   (if (= (vector-length x1780) '6)
                       (eq? (vector-ref x1780 '0) 'module-binding)
                       '#f)
                   '#f)))
            (module-binding-type423
             (lambda (x1143) (vector-ref x1143 '1)))
            (module-binding-id424
             (lambda (x1779) (vector-ref x1779 '2)))
            (module-binding-label425
             (lambda (x1144) (vector-ref x1144 '3)))
            (module-binding-imps426
             (lambda (x1778) (vector-ref x1778 '4)))
            (module-binding-val427
             (lambda (x1145) (vector-ref x1145 '5)))
            (set-module-binding-type!428
             (lambda (x1777 update1776)
               (vector-set! x1777 '1 update1776)))
            (set-module-binding-id!429
             (lambda (x1147 update1146)
               (vector-set! x1147 '2 update1146)))
            (set-module-binding-label!430
             (lambda (x1775 update1774)
               (vector-set! x1775 '3 update1774)))
            (set-module-binding-imps!431
             (lambda (x1149 update1148)
               (vector-set! x1149 '4 update1148)))
            (set-module-binding-val!432
             (lambda (x1773 update1772)
               (vector-set! x1773 '5 update1772)))
            (chi-top-module433
             (lambda (e1159
                      r1150
                      ribcage1158
                      w1151
                      s1157
                      ctem1152
                      rtem1156
                      id1153
                      exports1155
                      forms1154)
               ((lambda (fexports1160)
                  (chi-external438
                    ribcage1158
                    (source-wrap405 e1159 w1151 s1157)
                    (map (lambda (d1223) (cons r1150 d1223)) forms1154)
                    r1150
                    exports1155
                    fexports1160
                    ctem1152
                    (lambda (bindings1162 inits1161)
                      ((letrec ((partition1163
                                 (lambda (fexports1168
                                          bs1164
                                          svs1167
                                          ses1165
                                          ctdefs1166)
                                   (if (null? fexports1168)
                                       ((letrec ((partition1169
                                                  (lambda (bs1172
                                                           dvs1170
                                                           des1171)
                                                    (if (null? bs1172)
                                                        ((lambda (ses1175
                                                                  des1173
                                                                  inits1174)
                                                           (begin (for-each
                                                                    (lambda (x1191)
                                                                      (apply
                                                                        (lambda (t1195
                                                                                 label1192
                                                                                 sym1194
                                                                                 val1193)
                                                                          (if label1192
                                                                              (set-indirect-label!347
                                                                                label1192
                                                                                sym1194)
                                                                              (void)))
                                                                        x1191))
                                                                    ctdefs1166)
                                                                  (build-sequence236
                                                                    '#f
                                                                    (list (ct-eval/residualize445
                                                                            ctem1152
                                                                            (lambda ()
                                                                              (if (null?
                                                                                    ctdefs1166)
                                                                                  (chi-void460)
                                                                                  (build-sequence236
                                                                                    '#f
                                                                                    (map (lambda (x1186)
                                                                                           (apply
                                                                                             (lambda (t1190
                                                                                                      label1187
                                                                                                      sym1189
                                                                                                      val1188)
                                                                                               (list '$sc-put-cte
                                                                                                     (list 'quote
                                                                                                           sym1189)
                                                                                                     (if (eq? t1190
                                                                                                              'define-syntax-form)
                                                                                                         val1188
                                                                                                         (list 'quote
                                                                                                               (make-binding278
                                                                                                                 'module
                                                                                                                 (make-resolved-interface420
                                                                                                                   val1188
                                                                                                                   sym1189))))))
                                                                                             x1186))
                                                                                         ctdefs1166)))))
                                                                          (ct-eval/residualize445
                                                                            ctem1152
                                                                            (lambda ()
                                                                              ((lambda (n1176)
                                                                                 ((lambda (token1177)
                                                                                    ((lambda (b1178)
                                                                                       ((lambda ()
                                                                                          (if n1176
                                                                                              (list '$sc-put-cte
                                                                                                    (list 'quote
                                                                                                          (if (same-marks?392
                                                                                                                (wrap-marks311
                                                                                                                  (syntax-object-wrap253
                                                                                                                    id1153))
                                                                                                                (wrap-marks311
                                                                                                                  '((top))))
                                                                                                              n1176
                                                                                                              ((lambda (marks1179)
                                                                                                                 (make-syntax-object250
                                                                                                                   n1176
                                                                                                                   (make-wrap310
                                                                                                                     marks1179
                                                                                                                     (list (make-ribcage351
                                                                                                                             (vector
                                                                                                                               n1176)
                                                                                                                             (vector
                                                                                                                               marks1179)
                                                                                                                             (vector
                                                                                                                               (generate-id137
                                                                                                                                 n1176)))))))
                                                                                                               (wrap-marks311
                                                                                                                 (syntax-object-wrap253
                                                                                                                   id1153)))))
                                                                                                    b1178)
                                                                                              ((lambda (n1180)
                                                                                                 (build-sequence236
                                                                                                   '#f
                                                                                                   (list (list '$sc-put-cte
                                                                                                               (list 'quote
                                                                                                                     n1180)
                                                                                                               b1178)
                                                                                                         (do-top-import441
                                                                                                           n1180
                                                                                                           token1177))))
                                                                                               (generate-id137
                                                                                                 'tmp))))))
                                                                                     (list 'quote
                                                                                           (make-binding278
                                                                                             'module
                                                                                             (make-resolved-interface420
                                                                                               exports1155
                                                                                               token1177)))))
                                                                                  (generate-id137
                                                                                    n1176)))
                                                                               (if id1153
                                                                                   ((lambda (x1181)
                                                                                      ((lambda (e1182)
                                                                                         (if (annotation?126
                                                                                               e1182)
                                                                                             (annotation-expression
                                                                                               e1182)
                                                                                             e1182))
                                                                                       (if (syntax-object?251
                                                                                             x1181)
                                                                                           (syntax-object-expression252
                                                                                             x1181)
                                                                                           x1181)))
                                                                                    id1153)
                                                                                   '#f))))
                                                                          (if (null?
                                                                                svs1167)
                                                                              (chi-void460)
                                                                              (build-sequence236
                                                                                '#f
                                                                                (map (lambda (v1185)
                                                                                       (list 'define
                                                                                             v1185
                                                                                             (chi-void460)))
                                                                                     svs1167)))
                                                                          (rt-eval/residualize444
                                                                            rtem1156
                                                                            (lambda ()
                                                                              (build-body238
                                                                                '#f
                                                                                dvs1170
                                                                                des1173
                                                                                (build-sequence236
                                                                                  '#f
                                                                                  (list (if (null?
                                                                                              svs1167)
                                                                                            (chi-void460)
                                                                                            (build-sequence236
                                                                                              '#f
                                                                                              (map (lambda (v1184
                                                                                                            e1183)
                                                                                                     (list 'set!
                                                                                                           v1184
                                                                                                           e1183))
                                                                                                   svs1167
                                                                                                   ses1175)))
                                                                                        (if (null?
                                                                                              inits1174)
                                                                                            (chi-void460)
                                                                                            (build-sequence236
                                                                                              '#f
                                                                                              inits1174)))))))
                                                                          (chi-void460)))))
                                                         (map (lambda (x1198)
                                                                (chi446
                                                                  (cdr x1198)
                                                                  (car x1198)
                                                                  '(())))
                                                              ses1165)
                                                         (map (lambda (x1196)
                                                                (chi446
                                                                  (cdr x1196)
                                                                  (car x1196)
                                                                  '(())))
                                                              des1171)
                                                         (map (lambda (x1197)
                                                                (chi446
                                                                  (cdr x1197)
                                                                  (car x1197)
                                                                  '(())))
                                                              inits1161))
                                                        ((lambda (b1199)
                                                           ((lambda (t1200)
                                                              (if (memv t1200
                                                                        '(define-form))
                                                                  ((lambda (var1201)
                                                                     (begin (extend-store!435
                                                                              r1150
                                                                              (get-indirect-label346
                                                                                (module-binding-label425
                                                                                  b1199))
                                                                              (make-binding278
                                                                                'lexical
                                                                                var1201))
                                                                            (partition1169
                                                                              (cdr bs1172)
                                                                              (cons var1201
                                                                                    dvs1170)
                                                                              (cons (module-binding-val427
                                                                                      b1199)
                                                                                    des1171))))
                                                                   (gen-var465
                                                                     (module-binding-id424
                                                                       b1199)))
                                                                  (if (memv t1200
                                                                            '(define-syntax-form
                                                                               module-form))
                                                                      (partition1169
                                                                        (cdr bs1172)
                                                                        dvs1170
                                                                        des1171)
                                                                      (error 'sc-expand-internal
                                                                        '"unexpected module binding type"))))
                                                            (module-binding-type423
                                                              b1199)))
                                                         (car bs1172))))))
                                          partition1169)
                                        bs1164
                                        '()
                                        '())
                                       ((lambda (id1203 fexports1202)
                                          (letrec ((pluck-binding1204
                                                    (lambda (id1219
                                                             bs1216
                                                             succ1218
                                                             fail1217)
                                                      ((letrec ((loop1220
                                                                 (lambda (bs1222
                                                                          new-bs1221)
                                                                   (if (null?
                                                                         bs1222)
                                                                       (fail1217)
                                                                       (if (free-id=?397
                                                                             (module-binding-id424
                                                                               (car bs1222))
                                                                             id1219)
                                                                           (succ1218
                                                                             (car bs1222)
                                                                             (smart-append389
                                                                               (reverse
                                                                                 new-bs1221)
                                                                               (cdr bs1222)))
                                                                           (loop1220
                                                                             (cdr bs1222)
                                                                             (cons (car bs1222)
                                                                                   new-bs1221)))))))
                                                         loop1220)
                                                       bs1216
                                                       '()))))
                                            (pluck-binding1204
                                              id1203
                                              bs1164
                                              (lambda (b1206 bs1205)
                                                ((lambda (t1209
                                                          label1207
                                                          imps1208)
                                                   ((lambda (fexports1211
                                                             sym1210)
                                                      ((lambda (t1212)
                                                         (if (memv t1212
                                                                   '(define-form))
                                                             (begin (set-indirect-label!347
                                                                      label1207
                                                                      sym1210)
                                                                    (partition1163
                                                                      fexports1211
                                                                      bs1205
                                                                      (cons sym1210
                                                                            svs1167)
                                                                      (cons (module-binding-val427
                                                                              b1206)
                                                                            ses1165)
                                                                      ctdefs1166))
                                                             (if (memv t1212
                                                                       '(define-syntax-form))
                                                                 (partition1163
                                                                   fexports1211
                                                                   bs1205
                                                                   svs1167
                                                                   ses1165
                                                                   (cons (list t1209
                                                                               label1207
                                                                               sym1210
                                                                               (module-binding-val427
                                                                                 b1206))
                                                                         ctdefs1166))
                                                                 (if (memv t1212
                                                                           '(module-form))
                                                                     ((lambda (exports1213)
                                                                        (partition1163
                                                                          (append
                                                                            (flatten-exports412
                                                                              exports1213)
                                                                            fexports1211)
                                                                          bs1205
                                                                          svs1167
                                                                          ses1165
                                                                          (cons (list t1209
                                                                                      label1207
                                                                                      sym1210
                                                                                      exports1213)
                                                                                ctdefs1166)))
                                                                      (module-binding-val427
                                                                        b1206))
                                                                     (error 'sc-expand-internal
                                                                       '"unexpected module binding type")))))
                                                       t1209))
                                                    (append
                                                      imps1208
                                                      fexports1202)
                                                    (generate-id137
                                                      ((lambda (x1214)
                                                         ((lambda (e1215)
                                                            (if (annotation?126
                                                                  e1215)
                                                                (annotation-expression
                                                                  e1215)
                                                                e1215))
                                                          (if (syntax-object?251
                                                                x1214)
                                                              (syntax-object-expression252
                                                                x1214)
                                                              x1214)))
                                                       id1203))))
                                                 (module-binding-type423
                                                   b1206)
                                                 (module-binding-label425
                                                   b1206)
                                                 (module-binding-imps426
                                                   b1206)))
                                              (lambda ()
                                                (partition1163
                                                  fexports1202
                                                  bs1164
                                                  svs1167
                                                  ses1165
                                                  ctdefs1166)))))
                                        (car fexports1168)
                                        (cdr fexports1168))))))
                         partition1163)
                       fexports1160
                       bindings1162
                       '()
                       '()
                       '()))))
                (flatten-exports412 exports1155))))
            (id-set-diff434
             (lambda (exports1771 defs1770)
               (if (null? exports1771)
                   '()
                   (if (bound-id-member?403 (car exports1771) defs1770)
                       (id-set-diff434 (cdr exports1771) defs1770)
                       (cons (car exports1771)
                             (id-set-diff434
                               (cdr exports1771)
                               defs1770))))))
            (extend-store!435
             (lambda (r1226 label1224 binding1225)
               (set-cdr!
                 r1226
                 (extend-env293 label1224 binding1225 (cdr r1226)))))
            (check-module-exports436
             (lambda (source-exp1753 fexports1751 ids1752)
               (letrec ((defined?1754
                         (lambda (e1761 ids1760)
                           (ormap
                             (lambda (x1762)
                               (if (interface?414 x1762)
                                   ((lambda (token1763)
                                      (if token1763
                                          (lookup-import-binding-name386
                                            ((lambda (x1764)
                                               ((lambda (e1765)
                                                  (if (annotation?126
                                                        e1765)
                                                      (annotation-expression
                                                        e1765)
                                                      e1765))
                                                (if (syntax-object?251
                                                      x1764)
                                                    (syntax-object-expression252
                                                      x1764)
                                                    x1764)))
                                             e1761)
                                            token1763
                                            (wrap-marks311
                                              (syntax-object-wrap253
                                                e1761)))
                                          ((lambda (v1766)
                                             ((letrec ((lp1767
                                                        (lambda (i1768)
                                                          (if (>= i1768 '0)
                                                              ((lambda (t1769)
                                                                 (if t1769
                                                                     t1769
                                                                     (lp1767
                                                                       (- i1768
                                                                          '1))))
                                                               (bound-id=?399
                                                                 e1761
                                                                 (vector-ref
                                                                   v1766
                                                                   i1768)))
                                                              '#f))))
                                                lp1767)
                                              (- (vector-length v1766)
                                                 '1)))
                                           (interface-exports415 x1762))))
                                    (interface-token416 x1762))
                                   (bound-id=?399 e1761 x1762)))
                             ids1760))))
                 ((letrec ((loop1755
                            (lambda (fexports1757 missing1756)
                              (if (null? fexports1757)
                                  (if (not (null? missing1756))
                                      (syntax-error
                                        missing1756
                                        '"missing definition for export(s)")
                                      (void))
                                  ((lambda (e1759 fexports1758)
                                     (if (defined?1754 e1759 ids1752)
                                         (loop1755
                                           fexports1758
                                           missing1756)
                                         (loop1755
                                           fexports1758
                                           (cons e1759 missing1756))))
                                   (car fexports1757)
                                   (cdr fexports1757))))))
                    loop1755)
                  fexports1751
                  '()))))
            (check-defined-ids437
             (lambda (source-exp1228 ls1227)
               (letrec ((b-i=?1229
                         (lambda (x1266 y1265)
                           (if (symbol? x1266)
                               (if (symbol? y1265)
                                   (eq? x1266 y1265)
                                   (if (eq? x1266
                                            ((lambda (x1267)
                                               ((lambda (e1268)
                                                  (if (annotation?126
                                                        e1268)
                                                      (annotation-expression
                                                        e1268)
                                                      e1268))
                                                (if (syntax-object?251
                                                      x1267)
                                                    (syntax-object-expression252
                                                      x1267)
                                                    x1267)))
                                             y1265))
                                       (same-marks?392
                                         (wrap-marks311
                                           (syntax-object-wrap253 y1265))
                                         (wrap-marks311 '((top))))
                                       '#f))
                               (if (symbol? y1265)
                                   (if (eq? y1265
                                            ((lambda (x1269)
                                               ((lambda (e1270)
                                                  (if (annotation?126
                                                        e1270)
                                                      (annotation-expression
                                                        e1270)
                                                      e1270))
                                                (if (syntax-object?251
                                                      x1269)
                                                    (syntax-object-expression252
                                                      x1269)
                                                    x1269)))
                                             x1266))
                                       (same-marks?392
                                         (wrap-marks311
                                           (syntax-object-wrap253 x1266))
                                         (wrap-marks311 '((top))))
                                       '#f)
                                   (bound-id=?399 x1266 y1265)))))
                        (vfold1230
                         (lambda (v1243 p1241 cls1242)
                           ((lambda (len1244)
                              ((letrec ((lp1245
                                         (lambda (i1247 cls1246)
                                           (if (= i1247 len1244)
                                               cls1246
                                               (lp1245
                                                 (+ i1247 '1)
                                                 (p1241
                                                   (vector-ref v1243 i1247)
                                                   cls1246))))))
                                 lp1245)
                               '0
                               cls1242))
                            (vector-length v1243))))
                        (conflicts1231
                         (lambda (x1258 y1256 cls1257)
                           (if (interface?414 x1258)
                               (if (interface?414 y1256)
                                   (call-with-values
                                     (lambda ()
                                       ((lambda (xe1264 ye1263)
                                          (if (> (vector-length xe1264)
                                                 (vector-length ye1263))
                                              (values x1258 ye1263)
                                              (values y1256 xe1264)))
                                        (interface-exports415 x1258)
                                        (interface-exports415 y1256)))
                                     (lambda (iface1260 exports1259)
                                       (vfold1230
                                         exports1259
                                         (lambda (id1262 cls1261)
                                           (id-iface-conflicts1232
                                             id1262
                                             iface1260
                                             cls1261))
                                         cls1257)))
                                   (id-iface-conflicts1232
                                     y1256
                                     x1258
                                     cls1257))
                               (if (interface?414 y1256)
                                   (id-iface-conflicts1232
                                     x1258
                                     y1256
                                     cls1257)
                                   (if (b-i=?1229 x1258 y1256)
                                       (cons x1258 cls1257)
                                       cls1257)))))
                        (id-iface-conflicts1232
                         (lambda (id1250 iface1248 cls1249)
                           ((lambda (token1251)
                              (if token1251
                                  (if (lookup-import-binding-name386
                                        ((lambda (x1252)
                                           ((lambda (e1253)
                                              (if (annotation?126 e1253)
                                                  (annotation-expression
                                                    e1253)
                                                  e1253))
                                            (if (syntax-object?251 x1252)
                                                (syntax-object-expression252
                                                  x1252)
                                                x1252)))
                                         id1250)
                                        token1251
                                        (if (symbol? id1250)
                                            (wrap-marks311 '((top)))
                                            (wrap-marks311
                                              (syntax-object-wrap253
                                                id1250))))
                                      (cons id1250 cls1249)
                                      cls1249)
                                  (vfold1230
                                    (interface-exports415 iface1248)
                                    (lambda (*id1255 cls1254)
                                      (if (b-i=?1229 *id1255 id1250)
                                          (cons *id1255 cls1254)
                                          cls1254))
                                    cls1249)))
                            (interface-token416 iface1248)))))
                 (if (not (null? ls1227))
                     ((letrec ((lp1233
                                (lambda (x1236 ls1234 cls1235)
                                  (if (null? ls1234)
                                      (if (not (null? cls1235))
                                          ((lambda (cls1237)
                                             (syntax-error
                                               source-exp1228
                                               '"duplicate definition for "
                                               (symbol->string
                                                 (car cls1237))
                                               '" in"))
                                           (syntax-object->datum cls1235))
                                          (void))
                                      ((letrec ((lp21238
                                                 (lambda (ls21240 cls1239)
                                                   (if (null? ls21240)
                                                       (lp1233
                                                         (car ls1234)
                                                         (cdr ls1234)
                                                         cls1239)
                                                       (lp21238
                                                         (cdr ls21240)
                                                         (conflicts1231
                                                           x1236
                                                           (car ls21240)
                                                           cls1239))))))
                                         lp21238)
                                       ls1234
                                       cls1235)))))
                        lp1233)
                      (car ls1227)
                      (cdr ls1227)
                      '())
                     (void)))))
            (chi-external438
             (lambda (ribcage1669
                      source-exp1662
                      body1668
                      r1663
                      exports1667
                      fexports1664
                      ctem1666
                      k1665)
               (letrec ((return1670
                         (lambda (bindings1750 ids1748 inits1749)
                           (begin (check-defined-ids437
                                    source-exp1662
                                    ids1748)
                                  (check-module-exports436
                                    source-exp1662
                                    fexports1664
                                    ids1748)
                                  (k1665 bindings1750 inits1749))))
                        (get-implicit-exports1671
                         (lambda (id1739)
                           ((letrec ((f1740
                                      (lambda (exports1741)
                                        (if (null? exports1741)
                                            '()
                                            (if (if (pair?
                                                      (car exports1741))
                                                    (bound-id=?399
                                                      id1739
                                                      (caar exports1741))
                                                    '#f)
                                                (flatten-exports412
                                                  (cdar exports1741))
                                                (f1740
                                                  (cdr exports1741)))))))
                              f1740)
                            exports1667)))
                        (update-imp-exports1672
                         (lambda (bindings1743 exports1742)
                           ((lambda (exports1744)
                              (map (lambda (b1745)
                                     ((lambda (id1746)
                                        (if (not (bound-id-member?403
                                                   id1746
                                                   exports1744))
                                            b1745
                                            (make-module-binding421
                                              (module-binding-type423
                                                b1745)
                                              id1746
                                              (module-binding-label425
                                                b1745)
                                              (append
                                                (get-implicit-exports1671
                                                  id1746)
                                                (module-binding-imps426
                                                  b1745))
                                              (module-binding-val427
                                                b1745))))
                                      (module-binding-id424 b1745)))
                                   bindings1743))
                            (map (lambda (x1747)
                                   (if (pair? x1747) (car x1747) x1747))
                                 exports1742)))))
                 ((letrec ((parse1673
                            (lambda (body1677
                                     ids1674
                                     bindings1676
                                     inits1675)
                              (if (null? body1677)
                                  (return1670
                                    bindings1676
                                    ids1674
                                    inits1675)
                                  ((lambda (e1679 er1678)
                                     (call-with-values
                                       (lambda ()
                                         (syntax-type409
                                           e1679
                                           er1678
                                           '(())
                                           '#f
                                           ribcage1669))
                                       (lambda (type1684
                                                value1680
                                                e1683
                                                w1681
                                                s1682)
                                         ((lambda (t1685)
                                            (if (memv t1685 '(define-form))
                                                (parse-define456
                                                  e1683
                                                  w1681
                                                  s1682
                                                  (lambda (id1688
                                                           rhs1686
                                                           w1687)
                                                    ((lambda (id1689)
                                                       ((lambda (label1690)
                                                          ((lambda (imps1691)
                                                             ((lambda ()
                                                                (begin (extend-ribcage!382
                                                                         ribcage1669
                                                                         id1689
                                                                         label1690)
                                                                       (parse1673
                                                                         (cdr body1677)
                                                                         (cons id1689
                                                                               ids1674)
                                                                         (cons (make-module-binding421
                                                                                 type1684
                                                                                 id1689
                                                                                 label1690
                                                                                 imps1691
                                                                                 (cons er1678
                                                                                       (wrap404
                                                                                         rhs1686
                                                                                         w1687)))
                                                                               bindings1676)
                                                                         inits1675)))))
                                                           (get-implicit-exports1671
                                                             id1689)))
                                                        (gen-indirect-label345)))
                                                     (wrap404
                                                       id1688
                                                       w1687))))
                                                (if (memv t1685
                                                          '(define-syntax-form))
                                                    (parse-define-syntax457
                                                      e1683
                                                      w1681
                                                      s1682
                                                      (lambda (id1694
                                                               rhs1692
                                                               w1693)
                                                        ((lambda (id1695)
                                                           ((lambda (label1696)
                                                              ((lambda (imps1697)
                                                                 ((lambda (exp1698)
                                                                    ((lambda ()
                                                                       (begin (extend-store!435
                                                                                r1663
                                                                                (get-indirect-label346
                                                                                  label1696)
                                                                                (cons 'deferred
                                                                                      exp1698))
                                                                              (extend-ribcage!382
                                                                                ribcage1669
                                                                                id1695
                                                                                label1696)
                                                                              (parse1673
                                                                                (cdr body1677)
                                                                                (cons id1695
                                                                                      ids1674)
                                                                                (cons (make-module-binding421
                                                                                        type1684
                                                                                        id1695
                                                                                        label1696
                                                                                        imps1697
                                                                                        exp1698)
                                                                                      bindings1676)
                                                                                inits1675)))))
                                                                  (chi446
                                                                    rhs1692
                                                                    (transformer-env296
                                                                      er1678)
                                                                    w1693)))
                                                               (get-implicit-exports1671
                                                                 id1695)))
                                                            (gen-indirect-label345)))
                                                         (wrap404
                                                           id1694
                                                           w1693))))
                                                    (if (memv t1685
                                                              '(module-form))
                                                        ((lambda (*ribcage1699)
                                                           ((lambda (*w1700)
                                                              ((lambda ()
                                                                 (parse-module454
                                                                   e1683
                                                                   w1681
                                                                   s1682
                                                                   *w1700
                                                                   (lambda (id1703
                                                                            *exports1701
                                                                            forms1702)
                                                                     (chi-external438
                                                                       *ribcage1699
                                                                       (source-wrap405
                                                                         e1683
                                                                         w1681
                                                                         s1682)
                                                                       (map (lambda (d1711)
                                                                              (cons er1678
                                                                                    d1711))
                                                                            forms1702)
                                                                       r1663
                                                                       *exports1701
                                                                       (flatten-exports412
                                                                         *exports1701)
                                                                       ctem1666
                                                                       (lambda (*bindings1705
                                                                                *inits1704)
                                                                         ((lambda (iface1706)
                                                                            ((lambda (bindings1707)
                                                                               ((lambda (inits1708)
                                                                                  ((lambda ()
                                                                                     (if id1703
                                                                                         ((lambda (label1710
                                                                                                   imps1709)
                                                                                            (begin (extend-store!435
                                                                                                     r1663
                                                                                                     (get-indirect-label346
                                                                                                       label1710)
                                                                                                     (make-binding278
                                                                                                       'module
                                                                                                       iface1706))
                                                                                                   (extend-ribcage!382
                                                                                                     ribcage1669
                                                                                                     id1703
                                                                                                     label1710)
                                                                                                   (parse1673
                                                                                                     (cdr body1677)
                                                                                                     (cons id1703
                                                                                                           ids1674)
                                                                                                     (cons (make-module-binding421
                                                                                                             type1684
                                                                                                             id1703
                                                                                                             label1710
                                                                                                             imps1709
                                                                                                             *exports1701)
                                                                                                           bindings1707)
                                                                                                     inits1708)))
                                                                                          (gen-indirect-label345)
                                                                                          (get-implicit-exports1671
                                                                                            id1703))
                                                                                         ((lambda ()
                                                                                            (begin (do-import!453
                                                                                                     iface1706
                                                                                                     ribcage1669)
                                                                                                   (parse1673
                                                                                                     (cdr body1677)
                                                                                                     (cons iface1706
                                                                                                           ids1674)
                                                                                                     bindings1707
                                                                                                     inits1708))))))))
                                                                                (append
                                                                                  inits1675
                                                                                  *inits1704)))
                                                                             (append
                                                                               (if id1703
                                                                                   *bindings1705
                                                                                   (update-imp-exports1672
                                                                                     *bindings1705
                                                                                     *exports1701))
                                                                               bindings1676)))
                                                                          (make-trimmed-interface419
                                                                            *exports1701)))))))))
                                                            (make-wrap310
                                                              (wrap-marks311
                                                                w1681)
                                                              (cons *ribcage1699
                                                                    (wrap-subst312
                                                                      w1681)))))
                                                         (make-ribcage351
                                                           '()
                                                           '()
                                                           '()))
                                                        (if (memv t1685
                                                                  '(import-form))
                                                            (parse-import455
                                                              e1683
                                                              w1681
                                                              s1682
                                                              (lambda (mid1712)
                                                                ((lambda (mlabel1713)
                                                                   ((lambda (binding1714)
                                                                      ((lambda (t1715)
                                                                         (if (memv t1715
                                                                                   '(module))
                                                                             ((lambda (iface1716)
                                                                                (begin (if value1680
                                                                                           (extend-ribcage-barrier!383
                                                                                             ribcage1669
                                                                                             value1680)
                                                                                           (void))
                                                                                       (do-import!453
                                                                                         iface1716
                                                                                         ribcage1669)
                                                                                       (parse1673
                                                                                         (cdr body1677)
                                                                                         (cons iface1716
                                                                                               ids1674)
                                                                                         (update-imp-exports1672
                                                                                           bindings1676
                                                                                           (vector->list
                                                                                             (interface-exports415
                                                                                               iface1716)))
                                                                                         inits1675)))
                                                                              (binding-value280
                                                                                binding1714))
                                                                             (if (memv t1715
                                                                                       '(displaced-lexical))
                                                                                 (displaced-lexical-error297
                                                                                   mid1712)
                                                                                 (syntax-error
                                                                                   mid1712
                                                                                   '"import from unknown module"))))
                                                                       (binding-type279
                                                                         binding1714)))
                                                                    (lookup300
                                                                      mlabel1713
                                                                      r1663)))
                                                                 (id-var-name396
                                                                   mid1712
                                                                   '(())))))
                                                            (if (memv t1685
                                                                      '(begin-form))
                                                                ((lambda (tmp1717)
                                                                   ((lambda (tmp1718)
                                                                      (if tmp1718
                                                                          (apply
                                                                            (lambda (_1720
                                                                                     e11719)
                                                                              (parse1673
                                                                                ((letrec ((f1721
                                                                                           (lambda (forms1722)
                                                                                             (if (null?
                                                                                                   forms1722)
                                                                                                 (cdr body1677)
                                                                                                 (cons (cons er1678
                                                                                                             (wrap404
                                                                                                               (car forms1722)
                                                                                                               w1681))
                                                                                                       (f1721
                                                                                                         (cdr forms1722)))))))
                                                                                   f1721)
                                                                                 e11719)
                                                                                ids1674
                                                                                bindings1676
                                                                                inits1675))
                                                                            tmp1718)
                                                                          (syntax-error
                                                                            tmp1717)))
                                                                    ($syntax-dispatch
                                                                      tmp1717
                                                                      '(any .
                                                                            each-any))))
                                                                 e1683)
                                                                (if (memv t1685
                                                                          '(eval-when-form))
                                                                    ((lambda (tmp1724)
                                                                       ((lambda (tmp1725)
                                                                          (if tmp1725
                                                                              (apply
                                                                                (lambda (_1728
                                                                                         x1726
                                                                                         e11727)
                                                                                  (parse1673
                                                                                    (if (memq 'eval
                                                                                              (chi-when-list408
                                                                                                x1726
                                                                                                w1681))
                                                                                        ((letrec ((f1730
                                                                                                   (lambda (forms1731)
                                                                                                     (if (null?
                                                                                                           forms1731)
                                                                                                         (cdr body1677)
                                                                                                         (cons (cons er1678
                                                                                                                     (wrap404
                                                                                                                       (car forms1731)
                                                                                                                       w1681))
                                                                                                               (f1730
                                                                                                                 (cdr forms1731)))))))
                                                                                           f1730)
                                                                                         e11727)
                                                                                        (cdr body1677))
                                                                                    ids1674
                                                                                    bindings1676
                                                                                    inits1675))
                                                                                tmp1725)
                                                                              (syntax-error
                                                                                tmp1724)))
                                                                        ($syntax-dispatch
                                                                          tmp1724
                                                                          '(any each-any
                                                                                .
                                                                                each-any))))
                                                                     e1683)
                                                                    (if (memv t1685
                                                                              '(local-syntax-form))
                                                                        (chi-local-syntax459
                                                                          value1680
                                                                          e1683
                                                                          er1678
                                                                          w1681
                                                                          s1682
                                                                          (lambda (forms1736
                                                                                   er1733
                                                                                   w1735
                                                                                   s1734)
                                                                            (parse1673
                                                                              ((letrec ((f1737
                                                                                         (lambda (forms1738)
                                                                                           (if (null?
                                                                                                 forms1738)
                                                                                               (cdr body1677)
                                                                                               (cons (cons er1733
                                                                                                           (wrap404
                                                                                                             (car forms1738)
                                                                                                             w1735))
                                                                                                     (f1737
                                                                                                       (cdr forms1738)))))))
                                                                                 f1737)
                                                                               forms1736)
                                                                              ids1674
                                                                              bindings1676
                                                                              inits1675)))
                                                                        (return1670
                                                                          bindings1676
                                                                          ids1674
                                                                          (append
                                                                            inits1675
                                                                            (cons (cons er1678
                                                                                        (source-wrap405
                                                                                          e1683
                                                                                          w1681
                                                                                          s1682))
                                                                                  (cdr body1677))))))))))))
                                          type1684))))
                                   (cdar body1677)
                                   (caar body1677))))))
                    parse1673)
                  body1668
                  '()
                  '()
                  '()))))
            (vmap439
             (lambda (fn1272 v1271)
               ((letrec ((doloop1273
                          (lambda (i1275 ls1274)
                            (if (< i1275 '0)
                                ls1274
                                (doloop1273
                                  (- i1275 '1)
                                  (cons (fn1272 (vector-ref v1271 i1275))
                                        ls1274))))))
                  doloop1273)
                (- (vector-length v1271) '1)
                '())))
            (vfor-each440
             (lambda (fn1658 v1657)
               ((lambda (len1659)
                  ((letrec ((doloop1660
                             (lambda (i1661)
                               (if (not (= i1661 len1659))
                                   (begin (fn1658 (vector-ref v1657 i1661))
                                          (doloop1660 (+ i1661 '1)))
                                   (void)))))
                     doloop1660)
                   '0))
                (vector-length v1657))))
            (do-top-import441
             (lambda (mid1277 token1276)
               (list '$sc-put-cte
                     (list 'quote mid1277)
                     (list 'quote
                           (make-binding278 'do-import token1276)))))
            (update-mode-set442
             ((lambda (table1651)
                (lambda (when-list1653 mode-set1652)
                  (remq '-
                        (apply
                          append
                          (map (lambda (m1654)
                                 ((lambda (row1655)
                                    (map (lambda (s1656)
                                           (cdr (assq s1656 row1655)))
                                         when-list1653))
                                  (cdr (assq m1654 table1651))))
                               mode-set1652)))))
              '((l (load . l)
                   (compile . c)
                   (visit . v)
                   (revisit . r)
                   (eval . -))
                (c (load . -)
                   (compile . -)
                   (visit . -)
                   (revisit . -)
                   (eval . c))
                (v (load . v)
                   (compile . c)
                   (visit . v)
                   (revisit . -)
                   (eval . -))
                (r (load . r)
                   (compile . c)
                   (visit . -)
                   (revisit . r)
                   (eval . -))
                (e (load . -)
                   (compile . -)
                   (visit . -)
                   (revisit . -)
                   (eval . e)))))
            (initial-mode-set443
             (lambda (when-list1279 compiling-a-file1278)
               (apply
                 append
                 (map (lambda (s1280)
                        (if compiling-a-file1278
                            ((lambda (t1281)
                               (if (memv t1281 '(compile))
                                   '(c)
                                   (if (memv t1281 '(load))
                                       '(l)
                                       (if (memv t1281 '(visit))
                                           '(v)
                                           (if (memv t1281 '(revisit))
                                               '(r)
                                               '())))))
                             s1280)
                            ((lambda (t1282)
                               (if (memv t1282 '(eval)) '(e) '()))
                             s1280)))
                      when-list1279))))
            (rt-eval/residualize444
             (lambda (rtem1646 thunk1645)
               (if (memq 'e rtem1646)
                   (thunk1645)
                   ((lambda (thunk1647)
                      (if (memq 'v rtem1646)
                          (if ((lambda (t1648)
                                 (if t1648 t1648 (memq 'r rtem1646)))
                               (memq 'l rtem1646))
                              (thunk1647)
                              (thunk1647))
                          (if ((lambda (t1649)
                                 (if t1649 t1649 (memq 'r rtem1646)))
                               (memq 'l rtem1646))
                              (thunk1647)
                              (chi-void460))))
                    (if (memq 'c rtem1646)
                        ((lambda (x1650)
                           (begin (top-level-eval-hook127 x1650)
                                  (lambda () x1650)))
                         (thunk1645))
                        thunk1645)))))
            (ct-eval/residualize445
             (lambda (ctem1284 thunk1283)
               (if (memq 'e ctem1284)
                   (begin (top-level-eval-hook127 (thunk1283))
                          (chi-void460))
                   ((lambda (thunk1285)
                      (if (memq 'r ctem1284)
                          (if ((lambda (t1286)
                                 (if t1286 t1286 (memq 'v ctem1284)))
                               (memq 'l ctem1284))
                              (thunk1285)
                              (thunk1285))
                          (if ((lambda (t1287)
                                 (if t1287 t1287 (memq 'v ctem1284)))
                               (memq 'l ctem1284))
                              (thunk1285)
                              (chi-void460))))
                    (if (memq 'c ctem1284)
                        ((lambda (x1288)
                           (begin (top-level-eval-hook127 x1288)
                                  (lambda () x1288)))
                         (thunk1283))
                        thunk1283)))))
            (chi446
             (lambda (e1639 r1637 w1638)
               (call-with-values
                 (lambda () (syntax-type409 e1639 r1637 w1638 '#f '#f))
                 (lambda (type1644 value1640 e1643 w1641 s1642)
                   (chi-expr447
                     type1644
                     value1640
                     e1643
                     r1637
                     w1641
                     s1642)))))
            (chi-expr447
             (lambda (type1294 value1289 e1293 r1290 w1292 s1291)
               ((lambda (t1295)
                  (if (memv t1295 '(lexical))
                      value1289
                      (if (memv t1295 '(core))
                          (value1289 e1293 r1290 w1292 s1291)
                          (if (memv t1295 '(lexical-call))
                              (chi-application448
                                value1289
                                e1293
                                r1290
                                w1292
                                s1291)
                              (if (memv t1295 '(constant))
                                  (list 'quote
                                        (strip464
                                          (source-wrap405
                                            e1293
                                            w1292
                                            s1291)
                                          '(())))
                                  (if (memv t1295 '(global))
                                      value1289
                                      (if (memv t1295 '(call))
                                          (chi-application448
                                            (chi446
                                              (car e1293)
                                              r1290
                                              w1292)
                                            e1293
                                            r1290
                                            w1292
                                            s1291)
                                          (if (memv t1295 '(begin-form))
                                              ((lambda (tmp1296)
                                                 ((lambda (tmp1297)
                                                    (if tmp1297
                                                        (apply
                                                          (lambda (_1300
                                                                   e11298
                                                                   e21299)
                                                            (chi-sequence406
                                                              (cons e11298
                                                                    e21299)
                                                              r1290
                                                              w1292
                                                              s1291))
                                                          tmp1297)
                                                        (syntax-error
                                                          tmp1296)))
                                                  ($syntax-dispatch
                                                    tmp1296
                                                    '(any any
                                                          .
                                                          each-any))))
                                               e1293)
                                              (if (memv t1295
                                                        '(local-syntax-form))
                                                  (chi-local-syntax459
                                                    value1289
                                                    e1293
                                                    r1290
                                                    w1292
                                                    s1291
                                                    chi-sequence406)
                                                  (if (memv t1295
                                                            '(eval-when-form))
                                                      ((lambda (tmp1302)
                                                         ((lambda (tmp1303)
                                                            (if tmp1303
                                                                (apply
                                                                  (lambda (_1307
                                                                           x1304
                                                                           e11306
                                                                           e21305)
                                                                    (if (memq 'eval
                                                                              (chi-when-list408
                                                                                x1304
                                                                                w1292))
                                                                        (chi-sequence406
                                                                          (cons e11306
                                                                                e21305)
                                                                          r1290
                                                                          w1292
                                                                          s1291)
                                                                        (chi-void460)))
                                                                  tmp1303)
                                                                (syntax-error
                                                                  tmp1302)))
                                                          ($syntax-dispatch
                                                            tmp1302
                                                            '(any each-any
                                                                  any
                                                                  .
                                                                  each-any))))
                                                       e1293)
                                                      (if (memv t1295
                                                                '(define-form
                                                                   define-syntax-form
                                                                   module-form
                                                                   import-form))
                                                          (syntax-error
                                                            (source-wrap405
                                                              e1293
                                                              w1292
                                                              s1291)
                                                            '"invalid context for definition")
                                                          (if (memv t1295
                                                                    '(syntax))
                                                              (syntax-error
                                                                (source-wrap405
                                                                  e1293
                                                                  w1292
                                                                  s1291)
                                                                '"reference to pattern variable outside syntax form")
                                                              (if (memv t1295
                                                                        '(displaced-lexical))
                                                                  (displaced-lexical-error297
                                                                    (source-wrap405
                                                                      e1293
                                                                      w1292
                                                                      s1291))
                                                                  (syntax-error
                                                                    (source-wrap405
                                                                      e1293
                                                                      w1292
                                                                      s1291)))))))))))))))
                type1294)))
            (chi-application448
             (lambda (x1629 e1625 r1628 w1626 s1627)
               ((lambda (tmp1630)
                  ((lambda (tmp1631)
                     (if tmp1631
                         (apply
                           (lambda (e01633 e11632)
                             (cons x1629
                                   (map (lambda (e1635)
                                          (chi446 e1635 r1628 w1626))
                                        e11632)))
                           tmp1631)
                         ((lambda (_1636)
                            (syntax-error
                              (source-wrap405 e1625 w1626 s1627)))
                          tmp1630)))
                   ($syntax-dispatch tmp1630 '(any . each-any))))
                e1625)))
            (chi-set!449
             (lambda (e1314 r1310 w1313 s1311 rib1312)
               ((lambda (tmp1315)
                  ((lambda (tmp1316)
                     (if (if tmp1316
                             (apply
                               (lambda (_1319 id1317 val1318)
                                 (id?303 id1317))
                               tmp1316)
                             '#f)
                         (apply
                           (lambda (_1322 id1320 val1321)
                             ((lambda (n1323)
                                ((lambda (b1324)
                                   ((lambda (t1325)
                                      (if (memv t1325 '(macro!))
                                          ((lambda (id1327 val1326)
                                             (syntax-type409
                                               (chi-macro450
                                                 (binding-value280 b1324)
                                                 (list '#(syntax-object set! ((top) #(ribcage () () ()) #(ribcage #(id val) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(t) #(("m" top)) #("i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(b) #((top)) #("i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(n) #((top)) #("i")) #(ribcage #(_ id val) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(e r w s rib) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks same-marks? join-marks join-wraps smart-append make-trimmed-syntax-object make-binding-wrap lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage set-import-token-key! import-token-key import-token? make-import-token barrier-marker new-mark anti-mark the-anti-mark set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend lookup sanitize-binding lookup* displaced-lexical-error transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check source-annotation no-source unannotate set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id get-import-binding get-global-definition-hook put-global-definition-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()) #(ribcage (#(import-token *top*)) () ())))
                                                       id1327
                                                       val1326)
                                                 r1310
                                                 '(())
                                                 s1311
                                                 rib1312)
                                               r1310
                                               '(())
                                               s1311
                                               rib1312))
                                           (wrap404 id1320 w1313)
                                           (wrap404 val1321 w1313))
                                          (values
                                            'core
                                            (lambda (e1331
                                                     r1328
                                                     w1330
                                                     s1329)
                                              ((lambda (val1333 n1332)
                                                 ((lambda (b1334)
                                                    ((lambda (t1335)
                                                       (if (memv t1335
                                                                 '(lexical))
                                                           (list 'set!
                                                                 (binding-value280
                                                                   b1334)
                                                                 val1333)
                                                           (if (memv t1335
                                                                     '(global))
                                                               (list 'set!
                                                                     (binding-value280
                                                                       b1334)
                                                                     val1333)
                                                               (if (memv t1335
                                                                         '(displaced-lexical))
                                                                   (syntax-error
                                                                     (wrap404
                                                                       id1320
                                                                       w1330)
                                                                     '"identifier out of context")
                                                                   (syntax-error
                                                                     (source-wrap405
                                                                       e1331
                                                                       w1330
                                                                       s1329))))))
                                                     (binding-type279
                                                       b1334)))
                                                  (lookup300 n1332 r1328)))
                                               (chi446 val1321 r1328 w1330)
                                               (id-var-name396
                                                 id1320
                                                 w1330)))
                                            e1314
                                            w1313
                                            s1311)))
                                    (binding-type279 b1324)))
                                 (lookup300 n1323 r1310)))
                              (id-var-name396 id1320 w1313)))
                           tmp1316)
                         ((lambda (_1336)
                            (syntax-error
                              (source-wrap405 e1314 w1313 s1311)))
                          tmp1315)))
                   ($syntax-dispatch tmp1315 '(any any any))))
                e1314)))
            (chi-macro450
             (lambda (p1612 e1607 r1611 w1608 s1610 rib1609)
               (letrec ((rebuild-macro-output1613
                         (lambda (x1617 m1616)
                           (if (pair? x1617)
                               (cons (rebuild-macro-output1613
                                       (car x1617)
                                       m1616)
                                     (rebuild-macro-output1613
                                       (cdr x1617)
                                       m1616))
                               (if (syntax-object?251 x1617)
                                   ((lambda (w1618)
                                      ((lambda (ms1620 s1619)
                                         (make-syntax-object250
                                           (syntax-object-expression252
                                             x1617)
                                           (if (if (pair? ms1620)
                                                   (eq? (car ms1620) '#f)
                                                   '#f)
                                               (make-wrap310
                                                 (cdr ms1620)
                                                 (if rib1609
                                                     (cons rib1609
                                                           (cdr s1619))
                                                     (cdr s1619)))
                                               (make-wrap310
                                                 (cons m1616 ms1620)
                                                 (if rib1609
                                                     (cons rib1609
                                                           (cons 'shift
                                                                 s1619))
                                                     (cons 'shift
                                                           s1619))))))
                                       (wrap-marks311 w1618)
                                       (wrap-subst312 w1618)))
                                    (syntax-object-wrap253 x1617))
                                   (if (vector? x1617)
                                       ((lambda (n1621)
                                          ((lambda (v1622)
                                             ((lambda ()
                                                ((letrec ((doloop1623
                                                           (lambda (i1624)
                                                             (if (= i1624
                                                                    n1621)
                                                                 v1622
                                                                 (begin (vector-set!
                                                                          v1622
                                                                          i1624
                                                                          (rebuild-macro-output1613
                                                                            (vector-ref
                                                                              x1617
                                                                              i1624)
                                                                            m1616))
                                                                        (doloop1623
                                                                          (+ i1624
                                                                             '1)))))))
                                                   doloop1623)
                                                 '0))))
                                           (make-vector n1621)))
                                        (vector-length x1617))
                                       (if (symbol? x1617)
                                           (syntax-error
                                             (source-wrap405
                                               e1607
                                               w1608
                                               s1610)
                                             '"encountered raw symbol "
                                             (format '"~s" x1617)
                                             '" in output of macro")
                                           x1617)))))))
                 (rebuild-macro-output1613
                   ((lambda (out1614)
                      (if (procedure? out1614)
                          (out1614
                            (lambda (id1615)
                              (begin (if (not (identifier? id1615))
                                         (syntax-error
                                           id1615
                                           '"environment argument is not an identifier")
                                         (void))
                                     (lookup300
                                       (id-var-name396 id1615 '(()))
                                       r1611))))
                          out1614))
                    (p1612
                      (source-wrap405 e1607 (anti-mark368 w1608) s1610)))
                   (string '#\m)))))
            (chi-body451
             (lambda (body1340 outer-form1337 r1339 w1338)
               ((lambda (r1341)
                  ((lambda (ribcage1342)
                     ((lambda (w1343)
                        ((lambda (body1344)
                           ((lambda ()
                              (chi-internal452
                                ribcage1342
                                outer-form1337
                                body1344
                                r1341
                                (lambda (exprs1349
                                         ids1345
                                         vars1348
                                         vals1346
                                         inits1347)
                                  (begin (if (null? exprs1349)
                                             (syntax-error
                                               outer-form1337
                                               '"no expressions in body")
                                             (void))
                                         (build-body238
                                           '#f
                                           vars1348
                                           (map (lambda (x1351)
                                                  (chi446
                                                    (cdr x1351)
                                                    (car x1351)
                                                    '(())))
                                                vals1346)
                                           (build-sequence236
                                             '#f
                                             (map (lambda (x1350)
                                                    (chi446
                                                      (cdr x1350)
                                                      (car x1350)
                                                      '(())))
                                                  (append
                                                    inits1347
                                                    exprs1349))))))))))
                         (map (lambda (x1352)
                                (cons r1341 (wrap404 x1352 w1343)))
                              body1340)))
                      (make-wrap310
                        (wrap-marks311 w1338)
                        (cons ribcage1342 (wrap-subst312 w1338)))))
                   (make-ribcage351 '() '() '())))
                (cons '("placeholder" placeholder) r1339))))
            (chi-internal452
             (lambda (ribcage1531 source-exp1527 body1530 r1528 k1529)
               (letrec ((return1532
                         (lambda (exprs1606
                                  ids1602
                                  vars1605
                                  vals1603
                                  inits1604)
                           (begin (check-defined-ids437
                                    source-exp1527
                                    ids1602)
                                  (k1529
                                    exprs1606
                                    ids1602
                                    (reverse vars1605)
                                    (reverse vals1603)
                                    inits1604)))))
                 ((letrec ((parse1533
                            (lambda (body1538
                                     ids1534
                                     vars1537
                                     vals1535
                                     inits1536)
                              (if (null? body1538)
                                  (return1532
                                    body1538
                                    ids1534
                                    vars1537
                                    vals1535
                                    inits1536)
                                  ((lambda (e1540 er1539)
                                     (call-with-values
                                       (lambda ()
                                         (syntax-type409
                                           e1540
                                           er1539
                                           '(())
                                           '#f
                                           ribcage1531))
                                       (lambda (type1545
                                                value1541
                                                e1544
                                                w1542
                                                s1543)
                                         ((lambda (t1546)
                                            (if (memv t1546 '(define-form))
                                                (parse-define456
                                                  e1544
                                                  w1542
                                                  s1543
                                                  (lambda (id1549
                                                           rhs1547
                                                           w1548)
                                                    ((lambda (id1551
                                                              label1550)
                                                       ((lambda (var1552)
                                                          (begin (extend-ribcage!382
                                                                   ribcage1531
                                                                   id1551
                                                                   label1550)
                                                                 (extend-store!435
                                                                   r1528
                                                                   label1550
                                                                   (make-binding278
                                                                     'lexical
                                                                     var1552))
                                                                 (parse1533
                                                                   (cdr body1538)
                                                                   (cons id1551
                                                                         ids1534)
                                                                   (cons var1552
                                                                         vars1537)
                                                                   (cons (cons er1539
                                                                               (wrap404
                                                                                 rhs1547
                                                                                 w1548))
                                                                         vals1535)
                                                                   inits1536)))
                                                        (gen-var465
                                                          id1551)))
                                                     (wrap404 id1549 w1548)
                                                     (gen-label348))))
                                                (if (memv t1546
                                                          '(define-syntax-form))
                                                    (parse-define-syntax457
                                                      e1544
                                                      w1542
                                                      s1543
                                                      (lambda (id1555
                                                               rhs1553
                                                               w1554)
                                                        ((lambda (id1558
                                                                  label1556
                                                                  exp1557)
                                                           (begin (extend-ribcage!382
                                                                    ribcage1531
                                                                    id1558
                                                                    label1556)
                                                                  (extend-store!435
                                                                    r1528
                                                                    label1556
                                                                    (make-binding278
                                                                      'deferred
                                                                      exp1557))
                                                                  (parse1533
                                                                    (cdr body1538)
                                                                    (cons id1558
                                                                          ids1534)
                                                                    vars1537
                                                                    vals1535
                                                                    inits1536)))
                                                         (wrap404
                                                           id1555
                                                           w1554)
                                                         (gen-label348)
                                                         (chi446
                                                           rhs1553
                                                           (transformer-env296
                                                             er1539)
                                                           w1554))))
                                                    (if (memv t1546
                                                              '(module-form))
                                                        ((lambda (*ribcage1559)
                                                           ((lambda (*w1560)
                                                              ((lambda ()
                                                                 (parse-module454
                                                                   e1544
                                                                   w1542
                                                                   s1543
                                                                   *w1560
                                                                   (lambda (id1563
                                                                            exports1561
                                                                            forms1562)
                                                                     (chi-internal452
                                                                       *ribcage1559
                                                                       (source-wrap405
                                                                         e1544
                                                                         w1542
                                                                         s1543)
                                                                       (map (lambda (d1574)
                                                                              (cons er1539
                                                                                    d1574))
                                                                            forms1562)
                                                                       r1528
                                                                       (lambda (*body1568
                                                                                *ids1564
                                                                                *vars1567
                                                                                *vals1565
                                                                                *inits1566)
                                                                         (begin (check-module-exports436
                                                                                  source-exp1527
                                                                                  (flatten-exports412
                                                                                    exports1561)
                                                                                  *ids1564)
                                                                                ((lambda (iface1572
                                                                                          vars1569
                                                                                          vals1571
                                                                                          inits1570)
                                                                                   (if id1563
                                                                                       ((lambda (label1573)
                                                                                          (begin (extend-ribcage!382
                                                                                                   ribcage1531
                                                                                                   id1563
                                                                                                   label1573)
                                                                                                 (extend-store!435
                                                                                                   r1528
                                                                                                   label1573
                                                                                                   (make-binding278
                                                                                                     'module
                                                                                                     iface1572))
                                                                                                 (parse1533
                                                                                                   (cdr body1538)
                                                                                                   (cons id1563
                                                                                                         ids1534)
                                                                                                   vars1569
                                                                                                   vals1571
                                                                                                   inits1570)))
                                                                                        (gen-label348))
                                                                                       ((lambda ()
                                                                                          (begin (do-import!453
                                                                                                   iface1572
                                                                                                   ribcage1531)
                                                                                                 (parse1533
                                                                                                   (cdr body1538)
                                                                                                   (cons iface1572
                                                                                                         ids1534)
                                                                                                   vars1569
                                                                                                   vals1571
                                                                                                   inits1570))))))
                                                                                 (make-trimmed-interface419
                                                                                   exports1561)
                                                                                 (append
                                                                                   *vars1567
                                                                                   vars1537)
                                                                                 (append
                                                                                   *vals1565
                                                                                   vals1535)
                                                                                 (append
                                                                                   inits1536
                                                                                   *inits1566
                                                                                   *body1568))))))))))
                                                            (make-wrap310
                                                              (wrap-marks311
                                                                w1542)
                                                              (cons *ribcage1559
                                                                    (wrap-subst312
                                                                      w1542)))))
                                                         (make-ribcage351
                                                           '()
                                                           '()
                                                           '()))
                                                        (if (memv t1546
                                                                  '(import-form))
                                                            (parse-import455
                                                              e1544
                                                              w1542
                                                              s1543
                                                              (lambda (mid1575)
                                                                ((lambda (mlabel1576)
                                                                   ((lambda (binding1577)
                                                                      ((lambda (t1578)
                                                                         (if (memv t1578
                                                                                   '(module))
                                                                             ((lambda (iface1579)
                                                                                (begin (if value1541
                                                                                           (extend-ribcage-barrier!383
                                                                                             ribcage1531
                                                                                             value1541)
                                                                                           (void))
                                                                                       (do-import!453
                                                                                         iface1579
                                                                                         ribcage1531)
                                                                                       (parse1533
                                                                                         (cdr body1538)
                                                                                         (cons iface1579
                                                                                               ids1534)
                                                                                         vars1537
                                                                                         vals1535
                                                                                         inits1536)))
                                                                              (cdr binding1577))
                                                                             (if (memv t1578
                                                                                       '(displaced-lexical))
                                                                                 (displaced-lexical-error297
                                                                                   mid1575)
                                                                                 (syntax-error
                                                                                   mid1575
                                                                                   '"import from unknown module"))))
                                                                       (car binding1577)))
                                                                    (lookup300
                                                                      mlabel1576
                                                                      r1528)))
                                                                 (id-var-name396
                                                                   mid1575
                                                                   '(())))))
                                                            (if (memv t1546
                                                                      '(begin-form))
                                                                ((lambda (tmp1580)
                                                                   ((lambda (tmp1581)
                                                                      (if tmp1581
                                                                          (apply
                                                                            (lambda (_1583
                                                                                     e11582)
                                                                              (parse1533
                                                                                ((letrec ((f1584
                                                                                           (lambda (forms1585)
                                                                                             (if (null?
                                                                                                   forms1585)
                                                                                                 (cdr body1538)
                                                                                                 (cons (cons er1539
                                                                                                             (wrap404
                                                                                                               (car forms1585)
                                                                                                               w1542))
                                                                                                       (f1584
                                                                                                         (cdr forms1585)))))))
                                                                                   f1584)
                                                                                 e11582)
                                                                                ids1534
                                                                                vars1537
                                                                                vals1535
                                                                                inits1536))
                                                                            tmp1581)
                                                                          (syntax-error
                                                                            tmp1580)))
                                                                    ($syntax-dispatch
                                                                      tmp1580
                                                                      '(any .
                                                                            each-any))))
                                                                 e1544)
                                                                (if (memv t1546
                                                                          '(eval-when-form))
                                                                    ((lambda (tmp1587)
                                                                       ((lambda (tmp1588)
                                                                          (if tmp1588
                                                                              (apply
                                                                                (lambda (_1591
                                                                                         x1589
                                                                                         e11590)
                                                                                  (parse1533
                                                                                    (if (memq 'eval
                                                                                              (chi-when-list408
                                                                                                x1589
                                                                                                w1542))
                                                                                        ((letrec ((f1593
                                                                                                   (lambda (forms1594)
                                                                                                     (if (null?
                                                                                                           forms1594)
                                                                                                         (cdr body1538)
                                                                                                         (cons (cons er1539
                                                                                                                     (wrap404
                                                                                                                       (car forms1594)
                                                                                                                       w1542))
                                                                                                               (f1593
                                                                                                                 (cdr forms1594)))))))
                                                                                           f1593)
                                                                                         e11590)
                                                                                        (cdr body1538))
                                                                                    ids1534
                                                                                    vars1537
                                                                                    vals1535
                                                                                    inits1536))
                                                                                tmp1588)
                                                                              (syntax-error
                                                                                tmp1587)))
                                                                        ($syntax-dispatch
                                                                          tmp1587
                                                                          '(any each-any
                                                                                .
                                                                                each-any))))
                                                                     e1544)
                                                                    (if (memv t1546
                                                                              '(local-syntax-form))
                                                                        (chi-local-syntax459
                                                                          value1541
                                                                          e1544
                                                                          er1539
                                                                          w1542
                                                                          s1543
                                                                          (lambda (forms1599
                                                                                   er1596
                                                                                   w1598
                                                                                   s1597)
                                                                            (parse1533
                                                                              ((letrec ((f1600
                                                                                         (lambda (forms1601)
                                                                                           (if (null?
                                                                                                 forms1601)
                                                                                               (cdr body1538)
                                                                                               (cons (cons er1596
                                                                                                           (wrap404
                                                                                                             (car forms1601)
                                                                                                             w1598))
                                                                                                     (f1600
                                                                                                       (cdr forms1601)))))))
                                                                                 f1600)
                                                                               forms1599)
                                                                              ids1534
                                                                              vars1537
                                                                              vals1535
                                                                              inits1536)))
                                                                        (return1532
                                                                          (cons (cons er1539
                                                                                      (source-wrap405
                                                                                        e1544
                                                                                        w1542
                                                                                        s1543))
                                                                                (cdr body1538))
                                                                          ids1534
                                                                          vars1537
                                                                          vals1535
                                                                          inits1536)))))))))
                                          type1545))))
                                   (cdar body1538)
                                   (caar body1538))))))
                    parse1533)
                  body1530
                  '()
                  '()
                  '()
                  '()))))
            (do-import!453
             (lambda (interface1354 ribcage1353)
               ((lambda (token1355)
                  (if token1355
                      (extend-ribcage-subst!385 ribcage1353 token1355)
                      (vfor-each440
                        (lambda (id1356)
                          ((lambda (label11357)
                             (begin (if (not label11357)
                                        (syntax-error
                                          id1356
                                          '"exported identifier not visible")
                                        (void))
                                    (extend-ribcage!382
                                      ribcage1353
                                      id1356
                                      label11357)))
                           (id-var-name-loc395 id1356 '(()))))
                        (interface-exports415 interface1354))))
                (interface-token416 interface1354))))
            (parse-module454
             (lambda (e1495 w1491 s1494 *w1492 k1493)
               (letrec ((listify1496
                         (lambda (exports1521)
                           (if (null? exports1521)
                               '()
                               (cons ((lambda (tmp1522)
                                        ((lambda (tmp1523)
                                           (if tmp1523
                                               (apply
                                                 (lambda (ex1524)
                                                   (listify1496 ex1524))
                                                 tmp1523)
                                               ((lambda (x1526)
                                                  (if (id?303 x1526)
                                                      (wrap404
                                                        x1526
                                                        *w1492)
                                                      (syntax-error
                                                        (source-wrap405
                                                          e1495
                                                          w1491
                                                          s1494)
                                                        '"invalid exports list in")))
                                                tmp1522)))
                                         ($syntax-dispatch
                                           tmp1522
                                           'each-any)))
                                      (car exports1521))
                                     (listify1496 (cdr exports1521))))))
                        (return1497
                         (lambda (id1519 exports1517 forms1518)
                           (k1493
                             id1519
                             (listify1496 exports1517)
                             (map (lambda (x1520) (wrap404 x1520 *w1492))
                                  forms1518)))))
                 ((lambda (tmp1498)
                    ((lambda (tmp1499)
                       (if tmp1499
                           (apply
                             (lambda (_1502 ex1500 form1501)
                               (return1497 '#f ex1500 form1501))
                             tmp1499)
                           ((lambda (tmp1505)
                              (if (if tmp1505
                                      (apply
                                        (lambda (_1509
                                                 mid1506
                                                 ex1508
                                                 form1507)
                                          (id?303 mid1506))
                                        tmp1505)
                                      '#f)
                                  (apply
                                    (lambda (_1513 mid1510 ex1512 form1511)
                                      (return1497
                                        (wrap404 mid1510 w1491)
                                        ex1512
                                        form1511))
                                    tmp1505)
                                  ((lambda (_1516)
                                     (syntax-error
                                       (source-wrap405 e1495 w1491 s1494)))
                                   tmp1498)))
                            ($syntax-dispatch
                              tmp1498
                              '(any any each-any . each-any)))))
                     ($syntax-dispatch
                       tmp1498
                       '(any each-any . each-any))))
                  e1495))))
            (parse-import455
             (lambda (e1361 w1358 s1360 k1359)
               ((lambda (tmp1362)
                  ((lambda (tmp1363)
                     (if (if tmp1363
                             (apply
                               (lambda (_1365 mid1364) (id?303 mid1364))
                               tmp1363)
                             '#f)
                         (apply
                           (lambda (_1367 mid1366)
                             (k1359 (wrap404 mid1366 w1358)))
                           tmp1363)
                         ((lambda (_1368)
                            (syntax-error
                              (source-wrap405 e1361 w1358 s1360)))
                          tmp1362)))
                   ($syntax-dispatch tmp1362 '(any any))))
                e1361)))
            (parse-define456
             (lambda (e1464 w1461 s1463 k1462)
               ((lambda (tmp1465)
                  ((lambda (tmp1466)
                     (if (if tmp1466
                             (apply
                               (lambda (_1469 name1467 val1468)
                                 (id?303 name1467))
                               tmp1466)
                             '#f)
                         (apply
                           (lambda (_1472 name1470 val1471)
                             (k1462 name1470 val1471 w1461))
                           tmp1466)
                         ((lambda (tmp1473)
                            (if (if tmp1473
                                    (apply
                                      (lambda (_1478
                                               name1474
                                               args1477
                                               e11475
                                               e21476)
                                        (if (id?303 name1474)
                                            (valid-bound-ids?400
                                              (lambda-var-list466
                                                args1477))
                                            '#f))
                                      tmp1473)
                                    '#f)
                                (apply
                                  (lambda (_1483
                                           name1479
                                           args1482
                                           e11480
                                           e21481)
                                    (k1462
                                      (wrap404 name1479 w1461)
                                      (cons '#(syntax-object lambda ((top) #(ribcage #(_ name args e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(e w s k) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks same-marks? join-marks join-wraps smart-append make-trimmed-syntax-object make-binding-wrap lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage set-import-token-key! import-token-key import-token? make-import-token barrier-marker new-mark anti-mark the-anti-mark set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend lookup sanitize-binding lookup* displaced-lexical-error transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check source-annotation no-source unannotate set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id get-import-binding get-global-definition-hook put-global-definition-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()) #(ribcage (#(import-token *top*)) () ())))
                                            (wrap404
                                              (cons args1482
                                                    (cons e11480 e21481))
                                              w1461))
                                      '(())))
                                  tmp1473)
                                ((lambda (tmp1485)
                                   (if (if tmp1485
                                           (apply
                                             (lambda (_1487 name1486)
                                               (id?303 name1486))
                                             tmp1485)
                                           '#f)
                                       (apply
                                         (lambda (_1489 name1488)
                                           (k1462
                                             (wrap404 name1488 w1461)
                                             '#(syntax-object (void) ((top) #(ribcage #(_ name) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(e w s k) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks same-marks? join-marks join-wraps smart-append make-trimmed-syntax-object make-binding-wrap lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage set-import-token-key! import-token-key import-token? make-import-token barrier-marker new-mark anti-mark the-anti-mark set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend lookup sanitize-binding lookup* displaced-lexical-error transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check source-annotation no-source unannotate set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id get-import-binding get-global-definition-hook put-global-definition-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()) #(ribcage (#(import-token *top*)) () ())))
                                             '(())))
                                         tmp1485)
                                       ((lambda (_1490)
                                          (syntax-error
                                            (source-wrap405
                                              e1464
                                              w1461
                                              s1463)))
                                        tmp1465)))
                                 ($syntax-dispatch tmp1465 '(any any)))))
                          ($syntax-dispatch
                            tmp1465
                            '(any (any . any) any . each-any)))))
                   ($syntax-dispatch tmp1465 '(any any any))))
                e1464)))
            (parse-define-syntax457
             (lambda (e1372 w1369 s1371 k1370)
               ((lambda (tmp1373)
                  ((lambda (tmp1374)
                     (if (if tmp1374
                             (apply
                               (lambda (_1377 name1375 val1376)
                                 (id?303 name1375))
                               tmp1374)
                             '#f)
                         (apply
                           (lambda (_1380 name1378 val1379)
                             (k1370 name1378 val1379 w1369))
                           tmp1374)
                         ((lambda (_1381)
                            (syntax-error
                              (source-wrap405 e1372 w1369 s1371)))
                          tmp1373)))
                   ($syntax-dispatch tmp1373 '(any any any))))
                e1372)))
            (chi-lambda-clause458
             (lambda (e1438 c1434 r1437 w1435 k1436)
               ((lambda (tmp1439)
                  ((lambda (tmp1440)
                     (if tmp1440
                         (apply
                           (lambda (id1443 e11441 e21442)
                             ((lambda (ids1444)
                                (if (not (valid-bound-ids?400 ids1444))
                                    (syntax-error
                                      e1438
                                      '"invalid parameter list in")
                                    ((lambda (labels1446 new-vars1445)
                                       (k1436
                                         new-vars1445
                                         (chi-body451
                                           (cons e11441 e21442)
                                           e1438
                                           (extend-var-env*295
                                             labels1446
                                             new-vars1445
                                             r1437)
                                           (make-binding-wrap387
                                             ids1444
                                             labels1446
                                             w1435))))
                                     (gen-labels350 ids1444)
                                     (map gen-var465 ids1444))))
                              id1443))
                           tmp1440)
                         ((lambda (tmp1449)
                            (if tmp1449
                                (apply
                                  (lambda (ids1452 e11450 e21451)
                                    ((lambda (old-ids1453)
                                       (if (not (valid-bound-ids?400
                                                  old-ids1453))
                                           (syntax-error
                                             e1438
                                             '"invalid parameter list in")
                                           ((lambda (labels1455
                                                     new-vars1454)
                                              (k1436
                                                ((letrec ((f1457
                                                           (lambda (ls11459
                                                                    ls21458)
                                                             (if (null?
                                                                   ls11459)
                                                                 ls21458
                                                                 (f1457
                                                                   (cdr ls11459)
                                                                   (cons (car ls11459)
                                                                         ls21458))))))
                                                   f1457)
                                                 (cdr new-vars1454)
                                                 (car new-vars1454))
                                                (chi-body451
                                                  (cons e11450 e21451)
                                                  e1438
                                                  (extend-var-env*295
                                                    labels1455
                                                    new-vars1454
                                                    r1437)
                                                  (make-binding-wrap387
                                                    old-ids1453
                                                    labels1455
                                                    w1435))))
                                            (gen-labels350 old-ids1453)
                                            (map gen-var465 old-ids1453))))
                                     (lambda-var-list466 ids1452)))
                                  tmp1449)
                                ((lambda (_1460) (syntax-error e1438))
                                 tmp1439)))
                          ($syntax-dispatch
                            tmp1439
                            '(any any . each-any)))))
                   ($syntax-dispatch tmp1439 '(each-any any . each-any))))
                c1434)))
            (chi-local-syntax459
             (lambda (rec?1387 e1382 r1386 w1383 s1385 k1384)
               ((lambda (tmp1388)
                  ((lambda (tmp1389)
                     (if tmp1389
                         (apply
                           (lambda (_1394 id1390 val1393 e11391 e21392)
                             ((lambda (ids1395)
                                (if (not (valid-bound-ids?400 ids1395))
                                    (invalid-ids-error402
                                      (map (lambda (x1396)
                                             (wrap404 x1396 w1383))
                                           ids1395)
                                      (source-wrap405 e1382 w1383 s1385)
                                      '"keyword")
                                    ((lambda (labels1397)
                                       ((lambda (new-w1398)
                                          (k1384
                                            (cons e11391 e21392)
                                            (extend-env*294
                                              labels1397
                                              ((lambda (w1400 trans-r1399)
                                                 (map (lambda (x1402)
                                                        (make-binding278
                                                          'deferred
                                                          (chi446
                                                            x1402
                                                            trans-r1399
                                                            w1400)))
                                                      val1393))
                                               (if rec?1387
                                                   new-w1398
                                                   w1383)
                                               (transformer-env296 r1386))
                                              r1386)
                                            new-w1398
                                            s1385))
                                        (make-binding-wrap387
                                          ids1395
                                          labels1397
                                          w1383)))
                                     (gen-labels350 ids1395))))
                              id1390))
                           tmp1389)
                         ((lambda (_1405)
                            (syntax-error
                              (source-wrap405 e1382 w1383 s1385)))
                          tmp1388)))
                   ($syntax-dispatch
                     tmp1388
                     '(any #(each (any any)) any . each-any))))
                e1382)))
            (chi-void460 (lambda () (list 'void)))
            (ellipsis?461
             (lambda (x1406)
               (if (nonsymbol-id?302 x1406)
                   (literal-id=?398
                     x1406
                     '#(syntax-object ... ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (lambda-var-list gen-var strip strip* strip-annotation ellipsis? chi-void chi-local-syntax chi-lambda-clause parse-define-syntax parse-define parse-import parse-module do-import! chi-internal chi-body chi-macro chi-set! chi-application chi-expr chi ct-eval/residualize rt-eval/residualize initial-mode-set update-mode-set do-top-import vfor-each vmap chi-external check-defined-ids check-module-exports extend-store! id-set-diff chi-top-module set-module-binding-val! set-module-binding-imps! set-module-binding-label! set-module-binding-id! set-module-binding-type! module-binding-val module-binding-imps module-binding-label module-binding-id module-binding-type module-binding? make-module-binding make-resolved-interface make-trimmed-interface set-interface-token! set-interface-exports! interface-token interface-exports interface? make-interface flatten-exports chi-top chi-top-expr syntax-type chi-when-list chi-top-sequence chi-sequence source-wrap wrap bound-id-member? invalid-ids-error distinct-bound-ids? valid-bound-ids? bound-id=? literal-id=? free-id=? id-var-name id-var-name-loc id-var-name&marks id-var-name-loc&marks same-marks? join-marks join-wraps smart-append make-trimmed-syntax-object make-binding-wrap lookup-import-binding-name extend-ribcage-subst! extend-ribcage-barrier-help! extend-ribcage-barrier! extend-ribcage! make-empty-ribcage set-import-token-key! import-token-key import-token? make-import-token barrier-marker new-mark anti-mark the-anti-mark set-ribcage-labels! set-ribcage-marks! set-ribcage-symnames! ribcage-labels ribcage-marks ribcage-symnames ribcage? make-ribcage gen-labels label? gen-label set-indirect-label! get-indirect-label indirect-label? gen-indirect-label only-top-marked? top-marked? top-wrap empty-wrap wrap-subst wrap-marks make-wrap id-sym-name&marks id-sym-name id? nonsymbol-id? global-extend lookup sanitize-binding lookup* displaced-lexical-error transformer-env extend-var-env* extend-env* extend-env null-env binding? set-binding-value! set-binding-type! binding-value binding-type make-binding arg-check source-annotation no-source unannotate set-syntax-object-wrap! set-syntax-object-expression! syntax-object-wrap syntax-object-expression syntax-object? make-syntax-object self-evaluating? build-lexical-var build-body build-letrec build-sequence build-data build-primref build-lambda build-revisit-only build-visit-only build-cte-install build-module-definition build-global-definition build-global-assignment build-global-reference build-lexical-assignment build-lexical-reference build-conditional build-application generate-id get-import-binding get-global-definition-hook put-global-definition-hook gensym-hook error-hook local-eval-hook top-level-eval-hook annotation? fx>= fx<= fx> fx< fx= fx- fx+ noexpand let-values define-structure unless when) ((top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top) (top)) ("i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()) #(ribcage (#(import-token *top*)) () ()))))
                   '#f)))
            (strip-annotation462
             (lambda (x1428 parent1427)
               (if (pair? x1428)
                   ((lambda (new1429)
                      (begin (if parent1427
                                 (set-annotation-stripped!
                                   parent1427
                                   new1429)
                                 (void))
                             (set-car!
                               new1429
                               (strip-annotation462 (car x1428) '#f))
                             (set-cdr!
                               new1429
                               (strip-annotation462 (cdr x1428) '#f))
                             new1429))
                    (cons '#f '#f))
                   (if (annotation?126 x1428)
                       ((lambda (t1430)
                          (if t1430
                              t1430
                              (strip-annotation462
                                (annotation-expression x1428)
                                x1428)))
                        (annotation-stripped x1428))
                       (if (vector? x1428)
                           ((lambda (new1431)
                              (begin (if parent1427
                                         (set-annotation-stripped!
                                           parent1427
                                           new1431)
                                         (void))
                                     ((letrec ((loop1432
                                                (lambda (i1433)
                                                  (if (not (< i1433 '0))
                                                      (begin (vector-set!
                                                               new1431
                                                               i1433
                                                               (strip-annotation462
                                                                 (vector-ref
                                                                   x1428
                                                                   i1433)
                                                                 '#f))
                                                             (loop1432
                                                               (- i1433
                                                                  '1)))
                                                      (void)))))
                                        loop1432)
                                      (- (vector-length x1428) '1))
                                     new1431))
                            (make-vector (vector-length x1428)))
                           x1428)))))
            (strip*463
             (lambda (x1409 w1407 fn1408)
               (if (memq 'top (wrap-marks311 w1407))
                   (fn1408 x1409)
                   ((letrec ((f1410
                              (lambda (x1411)
                                (if (syntax-object?251 x1411)
                                    (strip*463
                                      (syntax-object-expression252 x1411)
                                      (syntax-object-wrap253 x1411)
                                      fn1408)
                                    (if (pair? x1411)
                                        ((lambda (a1413 d1412)
                                           (if (if (eq? a1413 (car x1411))
                                                   (eq? d1412 (cdr x1411))
                                                   '#f)
                                               x1411
                                               (cons a1413 d1412)))
                                         (f1410 (car x1411))
                                         (f1410 (cdr x1411)))
                                        (if (vector? x1411)
                                            ((lambda (old1414)
                                               ((lambda (new1415)
                                                  (if (andmap
                                                        eq?
                                                        old1414
                                                        new1415)
                                                      x1411
                                                      (list->vector
                                                        new1415)))
                                                (map f1410 old1414)))
                                             (vector->list x1411))
                                            x1411))))))
                      f1410)
                    x1409))))
            (strip464
             (lambda (x1424 w1423)
               (strip*463
                 x1424
                 w1423
                 (lambda (x1425)
                   (if ((lambda (t1426)
                          (if t1426
                              t1426
                              (if (pair? x1425)
                                  (annotation?126 (car x1425))
                                  '#f)))
                        (annotation?126 x1425))
                       (strip-annotation462 x1425 '#f)
                       x1425)))))
            (gen-var465
             (lambda (id1416)
               ((lambda (id1417)
                  (if (annotation?126 id1417) (gensym) (gensym)))
                (if (syntax-object?251 id1416)
                    (syntax-object-expression252 id1416)
                    id1416))))
            (lambda-var-list466
             (lambda (vars1418)
               ((letrec ((lvl1419
                          (lambda (vars1422 ls1420 w1421)
                            (if (pair? vars1422)
                                (lvl1419
                                  (cdr vars1422)
                                  (cons (wrap404 (car vars1422) w1421)
                                        ls1420)
                                  w1421)
                                (if (id?303 vars1422)
                                    (cons (wrap404 vars1422 w1421) ls1420)
                                    (if (null? vars1422)
                                        ls1420
                                        (if (syntax-object?251 vars1422)
                                            (lvl1419
                                              (syntax-object-expression252
                                                vars1422)
                                              ls1420
                                              (join-wraps390
                                                w1421
                                                (syntax-object-wrap253
                                                  vars1422)))
                                            (if (annotation?126 vars1422)
                                                (lvl1419
                                                  (annotation-expression
                                                    vars1422)
                                                  ls1420
                                                  w1421)
                                                (cons vars1422
                                                      ls1420)))))))))
                  lvl1419)
                vars1418
                '()
                '(())))))
     (begin (set! $sc-put-cte
              (lambda (id870 b869)
                (letrec ((put-token871
                          (lambda (id889 token888)
                            (letrec ((cons-id890
                                      (lambda (id900 x899)
                                        (if (not x899)
                                            id900
                                            (cons id900 x899))))
                                     (weed891
                                      (lambda (id897 x896)
                                        (if (pair? x896)
                                            (if (bound-id=?399
                                                  (car x896)
                                                  id897)
                                                (weed891 id897 (cdr x896))
                                                (cons-id890
                                                  (car x896)
                                                  (weed891
                                                    id897
                                                    (cdr x896))))
                                            (if ((lambda (t898)
                                                   (if t898
                                                       t898
                                                       (bound-id=?399
                                                         x896
                                                         id897)))
                                                 (not x896))
                                                '#f
                                                x896)))))
                              ((lambda (sym892)
                                 ((lambda (x893)
                                    (if (if (not x893) (symbol? id889) '#f)
                                        (remprop sym892 token888)
                                        (putprop
                                          sym892
                                          token888
                                          (cons-id890 id889 x893))))
                                  (weed891
                                    id889
                                    (getprop sym892 token888))))
                               ((lambda (x894)
                                  ((lambda (e895)
                                     (if (annotation?126 e895)
                                         (annotation-expression e895)
                                         e895))
                                   (if (syntax-object?251 x894)
                                       (syntax-object-expression252 x894)
                                       x894)))
                                id889)))))
                         (sc-put-module872
                          (lambda (exports883 token882)
                            (vfor-each440
                              (lambda (id884)
                                (put-token871 id884 token882))
                              exports883)))
                         (put-cte873
                          (lambda (id886 binding885)
                            (begin (put-token871 id886 '*top*)
                                   ((lambda (sym887)
                                      (putprop
                                        sym887
                                        '*sc-expander*
                                        binding885))
                                    (if (symbol? id886)
                                        id886
                                        (id-var-name396 id886 '(()))))))))
                  ((lambda (binding874)
                     ((lambda (t875)
                        (if (memv t875 '(module))
                            (begin ((lambda (iface876)
                                      (sc-put-module872
                                        (interface-exports415 iface876)
                                        (interface-token416 iface876)))
                                    (binding-value280 binding874))
                                   (put-cte873 id870 binding874))
                            (if (memv t875 '(do-import))
                                ((lambda (token877)
                                   ((lambda (b878)
                                      ((lambda (t879)
                                         (if (memv t879 '(module))
                                             ((lambda (iface880)
                                                (begin (if (not (eq? (interface-token416
                                                                       iface880)
                                                                     token877))
                                                           (syntax-error
                                                             id870
                                                             '"import mismatch for module")
                                                           (void))
                                                       (sc-put-module872
                                                         (interface-exports415
                                                           iface880)
                                                         '*top*)))
                                              (binding-value280 b878))
                                             (syntax-error
                                               id870
                                               '"import from unknown module")))
                                       (binding-type279 b878)))
                                    (lookup300
                                      (id-var-name396 id870 '(()))
                                      '())))
                                 (binding-value280 b869))
                                (put-cte873 id870 binding874))))
                      (binding-type279 binding874)))
                   ((lambda (t881)
                      (if t881
                          t881
                          (error 'define-syntax
                            '"invalid transformer ~s"
                            b869)))
                    (sanitize-binding299 b869))))))
            (global-extend301 'local-syntax 'letrec-syntax '#t)
            (global-extend301 'local-syntax 'let-syntax '#f)
            (global-extend301
              'core
              'fluid-let-syntax
              (lambda (e470 r467 w469 s468)
                ((lambda (tmp471)
                   ((lambda (tmp472)
                      (if (if tmp472
                              (apply
                                (lambda (_477 var473 val476 e1474 e2475)
                                  (valid-bound-ids?400 var473))
                                tmp472)
                              '#f)
                          (apply
                            (lambda (_483 var479 val482 e1480 e2481)
                              ((lambda (names484)
                                 (begin (for-each
                                          (lambda (id491 n490)
                                            ((lambda (t492)
                                               (if (memv t492
                                                         '(displaced-lexical))
                                                   (displaced-lexical-error297
                                                     (wrap404 id491 w469))
                                                   (void)))
                                             (binding-type279
                                               (lookup300 n490 r467))))
                                          var479
                                          names484)
                                        (chi-body451
                                          (cons e1480 e2481)
                                          (source-wrap405 e470 w469 s468)
                                          (extend-env*294
                                            names484
                                            ((lambda (trans-r485)
                                               (map (lambda (x487)
                                                      (make-binding278
                                                        'deferred
                                                        (chi446
                                                          x487
                                                          trans-r485
                                                          w469)))
                                                    val482))
                                             (transformer-env296 r467))
                                            r467)
                                          w469)))
                               (map (lambda (x494)
                                      (id-var-name396 x494 w469))
                                    var479)))
                            tmp472)
                          ((lambda (_495)
                             (syntax-error
                               (source-wrap405 e470 w469 s468)))
                           tmp471)))
                    ($syntax-dispatch
                      tmp471
                      '(any #(each (any any)) any . each-any))))
                 e470)))
            (global-extend301
              'core
              'quote
              (lambda (e863 r860 w862 s861)
                ((lambda (tmp864)
                   ((lambda (tmp865)
                      (if tmp865
                          (apply
                            (lambda (_867 e866)
                              (list 'quote (strip464 e866 w862)))
                            tmp865)
                          ((lambda (_868)
                             (syntax-error
                               (source-wrap405 e863 w862 s861)))
                           tmp864)))
                    ($syntax-dispatch tmp864 '(any any))))
                 e863)))
            (global-extend301
              'core
              'syntax
              ((lambda ()
                 (letrec ((gen-syntax496
                           (lambda (src554 e550 r553 maps551 ellipsis?552)
                             (if (id?303 e550)
                                 ((lambda (label555)
                                    ((lambda (b556)
                                       (if (eq? (binding-type279 b556)
                                                'syntax)
                                           (call-with-values
                                             (lambda ()
                                               ((lambda (var.lev559)
                                                  (gen-ref497
                                                    src554
                                                    (car var.lev559)
                                                    (cdr var.lev559)
                                                    maps551))
                                                (binding-value280 b556)))
                                             (lambda (var558 maps557)
                                               (values
                                                 (list 'ref var558)
                                                 maps557)))
                                           (if (ellipsis?552 e550)
                                               (syntax-error
                                                 src554
                                                 '"misplaced ellipsis in syntax form")
                                               (values
                                                 (list 'quote e550)
                                                 maps551))))
                                     (lookup300 label555 r553)))
                                  (id-var-name396 e550 '(())))
                                 ((lambda (tmp560)
                                    ((lambda (tmp561)
                                       (if (if tmp561
                                               (apply
                                                 (lambda (dots563 e562)
                                                   (ellipsis?552 dots563))
                                                 tmp561)
                                               '#f)
                                           (apply
                                             (lambda (dots565 e564)
                                               (gen-syntax496
                                                 src554
                                                 e564
                                                 r553
                                                 maps551
                                                 (lambda (x566) '#f)))
                                             tmp561)
                                           ((lambda (tmp567)
                                              (if (if tmp567
                                                      (apply
                                                        (lambda (x570
                                                                 dots568
                                                                 y569)
                                                          (ellipsis?552
                                                            dots568))
                                                        tmp567)
                                                      '#f)
                                                  (apply
                                                    (lambda (x573
                                                             dots571
                                                             y572)
                                                      ((letrec ((f574
                                                                 (lambda (y576
                                                                          k575)
                                                                   ((lambda (tmp577)
                                                                      ((lambda (tmp578)
                                                                         (if (if tmp578
                                                                                 (apply
                                                                                   (lambda (dots580
                                                                                            y579)
                                                                                     (ellipsis?552
                                                                                       dots580))
                                                                                   tmp578)
                                                                                 '#f)
                                                                             (apply
                                                                               (lambda (dots582
                                                                                        y581)
                                                                                 (f574 y581
                                                                                       (lambda (maps583)
                                                                                         (call-with-values
                                                                                           (lambda ()
                                                                                             (k575 (cons '()
                                                                                                         maps583)))
                                                                                           (lambda (x585
                                                                                                    maps584)
                                                                                             (if (null?
                                                                                                   (car maps584))
                                                                                                 (syntax-error
                                                                                                   src554
                                                                                                   '"extra ellipsis in syntax form")
                                                                                                 (values
                                                                                                   (gen-mappend499
                                                                                                     x585
                                                                                                     (car maps584))
                                                                                                   (cdr maps584))))))))
                                                                               tmp578)
                                                                             ((lambda (_586)
                                                                                (call-with-values
                                                                                  (lambda ()
                                                                                    (gen-syntax496
                                                                                      src554
                                                                                      y576
                                                                                      r553
                                                                                      maps551
                                                                                      ellipsis?552))
                                                                                  (lambda (y588
                                                                                           maps587)
                                                                                    (call-with-values
                                                                                      (lambda ()
                                                                                        (k575 maps587))
                                                                                      (lambda (x590
                                                                                               maps589)
                                                                                        (values
                                                                                          (gen-append498
                                                                                            x590
                                                                                            y588)
                                                                                          maps589))))))
                                                                              tmp577)))
                                                                       ($syntax-dispatch
                                                                         tmp577
                                                                         '(any .
                                                                               any))))
                                                                    y576))))
                                                         f574)
                                                       y572
                                                       (lambda (maps591)
                                                         (call-with-values
                                                           (lambda ()
                                                             (gen-syntax496
                                                               src554
                                                               x573
                                                               r553
                                                               (cons '()
                                                                     maps591)
                                                               ellipsis?552))
                                                           (lambda (x593
                                                                    maps592)
                                                             (if (null?
                                                                   (car maps592))
                                                                 (syntax-error
                                                                   src554
                                                                   '"extra ellipsis in syntax form")
                                                                 (values
                                                                   (gen-map500
                                                                     x593
                                                                     (car maps592))
                                                                   (cdr maps592))))))))
                                                    tmp567)
                                                  ((lambda (tmp594)
                                                     (if tmp594
                                                         (apply
                                                           (lambda (x596
                                                                    y595)
                                                             (call-with-values
                                                               (lambda ()
                                                                 (gen-syntax496
                                                                   src554
                                                                   x596
                                                                   r553
                                                                   maps551
                                                                   ellipsis?552))
                                                               (lambda (xnew598
                                                                        maps597)
                                                                 (call-with-values
                                                                   (lambda ()
                                                                     (gen-syntax496
                                                                       src554
                                                                       y595
                                                                       r553
                                                                       maps597
                                                                       ellipsis?552))
                                                                   (lambda (ynew600
                                                                            maps599)
                                                                     (values
                                                                       (gen-cons501
                                                                         e550
                                                                         x596
                                                                         y595
                                                                         xnew598
                                                                         ynew600)
                                                                       maps599))))))
                                                           tmp594)
                                                         ((lambda (tmp601)
                                                            (if tmp601
                                                                (apply
                                                                  (lambda (x1603
                                                                           x2602)
                                                                    ((lambda (ls604)
                                                                       (call-with-values
                                                                         (lambda ()
                                                                           (gen-syntax496
                                                                             src554
                                                                             ls604
                                                                             r553
                                                                             maps551
                                                                             ellipsis?552))
                                                                         (lambda (lsnew606
                                                                                  maps605)
                                                                           (values
                                                                             (gen-vector502
                                                                               e550
                                                                               ls604
                                                                               lsnew606)
                                                                             maps605))))
                                                                     (cons x1603
                                                                           x2602)))
                                                                  tmp601)
                                                                ((lambda (_608)
                                                                   (values
                                                                     (list 'quote
                                                                           e550)
                                                                     maps551))
                                                                 tmp560)))
                                                          ($syntax-dispatch
                                                            tmp560
                                                            '#(vector
                                                               (any .
                                                                    each-any))))))
                                                   ($syntax-dispatch
                                                     tmp560
                                                     '(any . any)))))
                                            ($syntax-dispatch
                                              tmp560
                                              '(any any . any)))))
                                     ($syntax-dispatch tmp560 '(any any))))
                                  e550))))
                          (gen-ref497
                           (lambda (src519 var516 level518 maps517)
                             (if (= level518 '0)
                                 (values var516 maps517)
                                 (if (null? maps517)
                                     (syntax-error
                                       src519
                                       '"missing ellipsis in syntax form")
                                     (call-with-values
                                       (lambda ()
                                         (gen-ref497
                                           src519
                                           var516
                                           (- level518 '1)
                                           (cdr maps517)))
                                       (lambda (outer-var521 outer-maps520)
                                         ((lambda (b522)
                                            (if b522
                                                (values (cdr b522) maps517)
                                                ((lambda (inner-var523)
                                                   (values
                                                     inner-var523
                                                     (cons (cons (cons outer-var521
                                                                       inner-var523)
                                                                 (car maps517))
                                                           outer-maps520)))
                                                 (gen-var465 'tmp))))
                                          (assq outer-var521
                                                (car maps517)))))))))
                          (gen-append498
                           (lambda (x549 y548)
                             (if (equal? y548 ''())
                                 x549
                                 (list 'append x549 y548))))
                          (gen-mappend499
                           (lambda (e525 map-env524)
                             (list 'apply
                                   '(primitive append)
                                   (gen-map500 e525 map-env524))))
                          (gen-map500
                           (lambda (e541 map-env540)
                             ((lambda (formals543 actuals542)
                                (if (eq? (car e541) 'ref)
                                    (car actuals542)
                                    (if (andmap
                                          (lambda (x544)
                                            (if (eq? (car x544) 'ref)
                                                (memq (cadr x544)
                                                      formals543)
                                                '#f))
                                          (cdr e541))
                                        (cons 'map
                                              (cons (list 'primitive
                                                          (car e541))
                                                    (map ((lambda (r545)
                                                            (lambda (x546)
                                                              (cdr (assq (cadr x546)
                                                                         r545))))
                                                          (map cons
                                                               formals543
                                                               actuals542))
                                                         (cdr e541))))
                                        (cons 'map
                                              (cons (list 'lambda
                                                          formals543
                                                          e541)
                                                    actuals542)))))
                              (map cdr map-env540)
                              (map (lambda (x547) (list 'ref (car x547)))
                                   map-env540))))
                          (gen-cons501
                           (lambda (e530 x526 y529 xnew527 ynew528)
                             ((lambda (t531)
                                (if (memv t531 '(quote))
                                    (if (eq? (car xnew527) 'quote)
                                        ((lambda (xnew533 ynew532)
                                           (if (if (eq? xnew533 x526)
                                                   (eq? ynew532 y529)
                                                   '#f)
                                               (list 'quote e530)
                                               (list 'quote
                                                     (cons xnew533
                                                           ynew532))))
                                         (cadr xnew527)
                                         (cadr ynew528))
                                        (if (eq? (cadr ynew528) '())
                                            (list 'list xnew527)
                                            (list 'cons xnew527 ynew528)))
                                    (if (memv t531 '(list))
                                        (cons 'list
                                              (cons xnew527 (cdr ynew528)))
                                        (list 'cons xnew527 ynew528))))
                              (car ynew528))))
                          (gen-vector502
                           (lambda (e539 ls537 lsnew538)
                             (if (eq? (car lsnew538) 'quote)
                                 (if (eq? (cadr lsnew538) ls537)
                                     (list 'quote e539)
                                     (list 'quote
                                           (list->vector (cadr lsnew538))))
                                 (if (eq? (car lsnew538) 'list)
                                     (cons 'vector (cdr lsnew538))
                                     (list 'list->vector lsnew538)))))
                          (regen503
                           (lambda (x534)
                             ((lambda (t535)
                                (if (memv t535 '(ref))
                                    (cadr x534)
                                    (if (memv t535 '(primitive))
                                        (cadr x534)
                                        (if (memv t535 '(quote))
                                            (list 'quote (cadr x534))
                                            (if (memv t535 '(lambda))
                                                (list 'lambda
                                                      (cadr x534)
                                                      (regen503
                                                        (caddr x534)))
                                                (if (memv t535 '(map))
                                                    ((lambda (ls536)
                                                       (cons (if (= (length
                                                                      ls536)
                                                                    '2)
                                                                 'map
                                                                 'map)
                                                             ls536))
                                                     (map regen503
                                                          (cdr x534)))
                                                    (cons (car x534)
                                                          (map regen503
                                                               (cdr x534)))))))))
                              (car x534)))))
                   (lambda (e507 r504 w506 s505)
                     ((lambda (e508)
                        ((lambda (tmp509)
                           ((lambda (tmp510)
                              (if tmp510
                                  (apply
                                    (lambda (_512 x511)
                                      (call-with-values
                                        (lambda ()
                                          (gen-syntax496
                                            e508
                                            x511
                                            r504
                                            '()
                                            ellipsis?461))
                                        (lambda (e514 maps513)
                                          (regen503 e514))))
                                    tmp510)
                                  ((lambda (_515) (syntax-error e508))
                                   tmp509)))
                            ($syntax-dispatch tmp509 '(any any))))
                         e508))
                      (source-wrap405 e507 w506 s505)))))))
            (global-extend301
              'core
              'lambda
              (lambda (e853 r850 w852 s851)
                ((lambda (tmp854)
                   ((lambda (tmp855)
                      (if tmp855
                          (apply
                            (lambda (_857 c856)
                              (chi-lambda-clause458
                                (source-wrap405 e853 w852 s851)
                                c856
                                r850
                                w852
                                (lambda (vars859 body858)
                                  (list 'lambda vars859 body858))))
                            tmp855)
                          (syntax-error tmp854)))
                    ($syntax-dispatch tmp854 '(any . any))))
                 e853)))
            (global-extend301
              'core
              'letrec
              (lambda (e612 r609 w611 s610)
                ((lambda (tmp613)
                   ((lambda (tmp614)
                      (if tmp614
                          (apply
                            (lambda (_619 id615 val618 e1616 e2617)
                              ((lambda (ids620)
                                 (if (not (valid-bound-ids?400 ids620))
                                     (invalid-ids-error402
                                       (map (lambda (x621)
                                              (wrap404 x621 w611))
                                            ids620)
                                       (source-wrap405 e612 w611 s610)
                                       '"bound variable")
                                     ((lambda (labels623 new-vars622)
                                        ((lambda (w625 r624)
                                           (build-letrec237
                                             s610
                                             new-vars622
                                             (map (lambda (x628)
                                                    (chi446
                                                      x628
                                                      r624
                                                      w625))
                                                  val618)
                                             (chi-body451
                                               (cons e1616 e2617)
                                               (source-wrap405
                                                 e612
                                                 w625
                                                 s610)
                                               r624
                                               w625)))
                                         (make-binding-wrap387
                                           ids620
                                           labels623
                                           w611)
                                         (extend-var-env*295
                                           labels623
                                           new-vars622
                                           r609)))
                                      (gen-labels350 ids620)
                                      (map gen-var465 ids620))))
                               id615))
                            tmp614)
                          ((lambda (_630)
                             (syntax-error
                               (source-wrap405 e612 w611 s610)))
                           tmp613)))
                    ($syntax-dispatch
                      tmp613
                      '(any #(each (any any)) any . each-any))))
                 e612)))
            (global-extend301
              'core
              'if
              (lambda (e838 r835 w837 s836)
                ((lambda (tmp839)
                   ((lambda (tmp840)
                      (if tmp840
                          (apply
                            (lambda (_843 test841 then842)
                              (list 'if
                                    (chi446 test841 r835 w837)
                                    (chi446 then842 r835 w837)
                                    (chi-void460)))
                            tmp840)
                          ((lambda (tmp844)
                             (if tmp844
                                 (apply
                                   (lambda (_848 test845 then847 else846)
                                     (list 'if
                                           (chi446 test845 r835 w837)
                                           (chi446 then847 r835 w837)
                                           (chi446 else846 r835 w837)))
                                   tmp844)
                                 ((lambda (_849)
                                    (syntax-error
                                      (source-wrap405 e838 w837 s836)))
                                  tmp839)))
                           ($syntax-dispatch tmp839 '(any any any any)))))
                    ($syntax-dispatch tmp839 '(any any any))))
                 e838)))
            (global-extend301 'set! 'set! '())
            (global-extend301 'begin 'begin '())
            (global-extend301 'module-key 'module '())
            (global-extend301 'import 'import '#f)
            (global-extend301 'import 'import-only '#t)
            (global-extend301 'define 'define '())
            (global-extend301 'define-syntax 'define-syntax '())
            (global-extend301 'eval-when 'eval-when '())
            (global-extend301
              'core
              'syntax-case
              ((lambda ()
                 (letrec ((convert-pattern631
                           (lambda (pattern700 keys699)
                             (letrec ((cvt*701
                                       (lambda (p*746 n744 ids745)
                                         (if (null? p*746)
                                             (values '() ids745)
                                             (call-with-values
                                               (lambda ()
                                                 (cvt*701
                                                   (cdr p*746)
                                                   n744
                                                   ids745))
                                               (lambda (y748 ids747)
                                                 (call-with-values
                                                   (lambda ()
                                                     (cvt702
                                                       (car p*746)
                                                       n744
                                                       ids747))
                                                   (lambda (x750 ids749)
                                                     (values
                                                       (cons x750 y748)
                                                       ids749))))))))
                                      (cvt702
                                       (lambda (p705 n703 ids704)
                                         (if (id?303 p705)
                                             (if (bound-id-member?403
                                                   p705
                                                   keys699)
                                                 (values
                                                   (vector 'free-id p705)
                                                   ids704)
                                                 (values
                                                   'any
                                                   (cons (cons p705 n703)
                                                         ids704)))
                                             ((lambda (tmp706)
                                                ((lambda (tmp707)
                                                   (if (if tmp707
                                                           (apply
                                                             (lambda (x709
                                                                      dots708)
                                                               (ellipsis?461
                                                                 dots708))
                                                             tmp707)
                                                           '#f)
                                                       (apply
                                                         (lambda (x711
                                                                  dots710)
                                                           (call-with-values
                                                             (lambda ()
                                                               (cvt702
                                                                 x711
                                                                 (+ n703
                                                                    '1)
                                                                 ids704))
                                                             (lambda (p713
                                                                      ids712)
                                                               (values
                                                                 (if (eq? p713
                                                                          'any)
                                                                     'each-any
                                                                     (vector
                                                                       'each
                                                                       p713))
                                                                 ids712))))
                                                         tmp707)
                                                       ((lambda (tmp714)
                                                          (if (if tmp714
                                                                  (apply
                                                                    (lambda (x718
                                                                             dots715
                                                                             y717
                                                                             z716)
                                                                      (ellipsis?461
                                                                        dots715))
                                                                    tmp714)
                                                                  '#f)
                                                              (apply
                                                                (lambda (x722
                                                                         dots719
                                                                         y721
                                                                         z720)
                                                                  (call-with-values
                                                                    (lambda ()
                                                                      (cvt702
                                                                        z720
                                                                        n703
                                                                        ids704))
                                                                    (lambda (z724
                                                                             ids723)
                                                                      (call-with-values
                                                                        (lambda ()
                                                                          (cvt*701
                                                                            y721
                                                                            n703
                                                                            ids723))
                                                                        (lambda (y726
                                                                                 ids725)
                                                                          (call-with-values
                                                                            (lambda ()
                                                                              (cvt702
                                                                                x722
                                                                                (+ n703
                                                                                   '1)
                                                                                ids725))
                                                                            (lambda (x728
                                                                                     ids727)
                                                                              (values
                                                                                (vector
                                                                                  'each+
                                                                                  x728
                                                                                  (reverse
                                                                                    y726)
                                                                                  z724)
                                                                                ids727))))))))
                                                                tmp714)
                                                              ((lambda (tmp730)
                                                                 (if tmp730
                                                                     (apply
                                                                       (lambda (x732
                                                                                y731)
                                                                         (call-with-values
                                                                           (lambda ()
                                                                             (cvt702
                                                                               y731
                                                                               n703
                                                                               ids704))
                                                                           (lambda (y734
                                                                                    ids733)
                                                                             (call-with-values
                                                                               (lambda ()
                                                                                 (cvt702
                                                                                   x732
                                                                                   n703
                                                                                   ids733))
                                                                               (lambda (x736
                                                                                        ids735)
                                                                                 (values
                                                                                   (cons x736
                                                                                         y734)
                                                                                   ids735))))))
                                                                       tmp730)
                                                                     ((lambda (tmp737)
                                                                        (if tmp737
                                                                            (apply
                                                                              (lambda ()
                                                                                (values
                                                                                  '()
                                                                                  ids704))
                                                                              tmp737)
                                                                            ((lambda (tmp738)
                                                                               (if tmp738
                                                                                   (apply
                                                                                     (lambda (x739)
                                                                                       (call-with-values
                                                                                         (lambda ()
                                                                                           (cvt702
                                                                                             x739
                                                                                             n703
                                                                                             ids704))
                                                                                         (lambda (p741
                                                                                                  ids740)
                                                                                           (values
                                                                                             (vector
                                                                                               'vector
                                                                                               p741)
                                                                                             ids740))))
                                                                                     tmp738)
                                                                                   ((lambda (x743)
                                                                                      (values
                                                                                        (vector
                                                                                          'atom
                                                                                          (strip464
                                                                                            p705
                                                                                            '(())))
                                                                                        ids704))
                                                                                    tmp706)))
                                                                             ($syntax-dispatch
                                                                               tmp706
                                                                               '#(vector
                                                                                  each-any)))))
                                                                      ($syntax-dispatch
                                                                        tmp706
                                                                        '()))))
                                                               ($syntax-dispatch
                                                                 tmp706
                                                                 '(any .
                                                                       any)))))
                                                        ($syntax-dispatch
                                                          tmp706
                                                          '(any any
                                                                .
                                                                #(each+
                                                                  any
                                                                  ()
                                                                  any))))))
                                                 ($syntax-dispatch
                                                   tmp706
                                                   '(any any))))
                                              p705)))))
                               (cvt702 pattern700 '0 '()))))
                          (build-dispatch-call632
                           (lambda (pvars654 exp651 y653 r652)
                             ((lambda (ids656 levels655)
                                ((lambda (labels658 new-vars657)
                                   (list 'apply
                                         (list 'lambda
                                               new-vars657
                                               (chi446
                                                 exp651
                                                 (extend-env*294
                                                   labels658
                                                   (map (lambda (var660
                                                                 level659)
                                                          (make-binding278
                                                            'syntax
                                                            (cons var660
                                                                  level659)))
                                                        new-vars657
                                                        (map cdr pvars654))
                                                   r652)
                                                 (make-binding-wrap387
                                                   ids656
                                                   labels658
                                                   '(()))))
                                         y653))
                                 (gen-labels350 ids656)
                                 (map gen-var465 ids656)))
                              (map car pvars654)
                              (map cdr pvars654))))
                          (gen-clause633
                           (lambda (x682
                                    keys676
                                    clauses681
                                    r677
                                    pat680
                                    fender678
                                    exp679)
                             (call-with-values
                               (lambda ()
                                 (convert-pattern631 pat680 keys676))
                               (lambda (p684 pvars683)
                                 (if (not (distinct-bound-ids?401
                                            (map car pvars683)))
                                     (invalid-ids-error402
                                       (map car pvars683)
                                       pat680
                                       '"pattern variable")
                                     (if (not (andmap
                                                (lambda (x685)
                                                  (not (ellipsis?461
                                                         (car x685))))
                                                pvars683))
                                         (syntax-error
                                           pat680
                                           '"misplaced ellipsis in syntax-case pattern")
                                         ((lambda (y686)
                                            (list (list 'lambda
                                                        (list y686)
                                                        (list 'if
                                                              ((lambda (tmp696)
                                                                 ((lambda (tmp697)
                                                                    (if tmp697
                                                                        (apply
                                                                          (lambda ()
                                                                            y686)
                                                                          tmp697)
                                                                        ((lambda (_698)
                                                                           (list 'if
                                                                                 y686
                                                                                 (build-dispatch-call632
                                                                                   pvars683
                                                                                   fender678
                                                                                   y686
                                                                                   r677)
                                                                                 (list 'quote
                                                                                       '#f)))
                                                                         tmp696)))
                                                                  ($syntax-dispatch
                                                                    tmp696
                                                                    '#(atom
                                                                       #t))))
                                                               fender678)
                                                              (build-dispatch-call632
                                                                pvars683
                                                                exp679
                                                                y686
                                                                r677)
                                                              (gen-syntax-case634
                                                                x682
                                                                keys676
                                                                clauses681
                                                                r677)))
                                                  (if (eq? p684 'any)
                                                      (list 'list x682)
                                                      (list '$syntax-dispatch
                                                            x682
                                                            (list 'quote
                                                                  p684)))))
                                          (gen-var465 'tmp))))))))
                          (gen-syntax-case634
                           (lambda (x664 keys661 clauses663 r662)
                             (if (null? clauses663)
                                 (list 'syntax-error x664)
                                 ((lambda (tmp665)
                                    ((lambda (tmp666)
                                       (if tmp666
                                           (apply
                                             (lambda (pat668 exp667)
                                               (if (if (id?303 pat668)
                                                       (if (not (bound-id-member?403
                                                                  pat668
                                                                  keys661))
                                                           (not (ellipsis?461
                                                                  pat668))
                                                           '#f)
                                                       '#f)
                                                   ((lambda (label670
                                                             var669)
                                                      (list (list 'lambda
                                                                  (list var669)
                                                                  (chi446
                                                                    exp667
                                                                    (extend-env293
                                                                      label670
                                                                      (make-binding278
                                                                        'syntax
                                                                        (cons var669
                                                                              '0))
                                                                      r662)
                                                                    (make-binding-wrap387
                                                                      (list pat668)
                                                                      (list label670)
                                                                      '(()))))
                                                            x664))
                                                    (gen-label348)
                                                    (gen-var465 pat668))
                                                   (gen-clause633
                                                     x664
                                                     keys661
                                                     (cdr clauses663)
                                                     r662
                                                     pat668
                                                     '#t
                                                     exp667)))
                                             tmp666)
                                           ((lambda (tmp671)
                                              (if tmp671
                                                  (apply
                                                    (lambda (pat674
                                                             fender672
                                                             exp673)
                                                      (gen-clause633
                                                        x664
                                                        keys661
                                                        (cdr clauses663)
                                                        r662
                                                        pat674
                                                        fender672
                                                        exp673))
                                                    tmp671)
                                                  ((lambda (_675)
                                                     (syntax-error
                                                       (car clauses663)
                                                       '"invalid syntax-case clause"))
                                                   tmp665)))
                                            ($syntax-dispatch
                                              tmp665
                                              '(any any any)))))
                                     ($syntax-dispatch tmp665 '(any any))))
                                  (car clauses663))))))
                   (lambda (e638 r635 w637 s636)
                     ((lambda (e639)
                        ((lambda (tmp640)
                           ((lambda (tmp641)
                              (if tmp641
                                  (apply
                                    (lambda (_645 val642 key644 m643)
                                      (if (andmap
                                            (lambda (x647)
                                              (if (id?303 x647)
                                                  (not (ellipsis?461 x647))
                                                  '#f))
                                            key644)
                                          ((lambda (x648)
                                             (list (list 'lambda
                                                         (list x648)
                                                         (gen-syntax-case634
                                                           x648
                                                           key644
                                                           m643
                                                           r635))
                                                   (chi446
                                                     val642
                                                     r635
                                                     '(()))))
                                           (gen-var465 'tmp))
                                          (syntax-error
                                            e639
                                            '"invalid literals list in")))
                                    tmp641)
                                  (syntax-error tmp640)))
                            ($syntax-dispatch
                              tmp640
                              '(any any each-any . each-any))))
                         e639))
                      (source-wrap405 e638 w637 s636)))))))
            (set! sc-expand
              ((lambda (ctem831 rtem829 user-ribcage830)
                 ((lambda (user-top-wrap832)
                    (lambda (x833)
                      (if (if (pair? x833)
                              (equal? (car x833) noexpand62)
                              '#f)
                          (cadr x833)
                          (chi-top411
                            x833
                            '()
                            user-top-wrap832
                            ctem831
                            rtem829
                            user-ribcage830))))
                  (make-wrap310
                    (wrap-marks311 '((top)))
                    (cons user-ribcage830 (wrap-subst312 '((top)))))))
               '(e)
               '(e)
               ((lambda (ribcage834)
                  (begin (extend-ribcage-subst!385 ribcage834 '*top*)
                         ribcage834))
                (make-ribcage351 '() '() '()))))
            (set! identifier? (lambda (x751) (nonsymbol-id?302 x751)))
            (set! datum->syntax-object
              (lambda (id827 datum826)
                (begin ((lambda (x828)
                          (if (not (nonsymbol-id?302 x828))
                              (error-hook129
                                'datum->syntax-object
                                '"invalid argument"
                                x828)
                              (void)))
                        id827)
                       (make-syntax-object250
                         datum826
                         (syntax-object-wrap253 id827)))))
            (set! syntax-object->datum
              (lambda (x752) (strip464 x752 '(()))))
            (set! generate-temporaries
              (lambda (ls823)
                (begin ((lambda (x825)
                          (if (not (list? x825))
                              (error-hook129
                                'generate-temporaries
                                '"invalid argument"
                                x825)
                              (void)))
                        ls823)
                       (map (lambda (x824) (wrap404 (gensym) '((top))))
                            ls823))))
            (set! free-identifier=?
              (lambda (x754 y753)
                (begin ((lambda (x756)
                          (if (not (nonsymbol-id?302 x756))
                              (error-hook129
                                'free-identifier=?
                                '"invalid argument"
                                x756)
                              (void)))
                        x754)
                       ((lambda (x755)
                          (if (not (nonsymbol-id?302 x755))
                              (error-hook129
                                'free-identifier=?
                                '"invalid argument"
                                x755)
                              (void)))
                        y753)
                       (free-id=?397 x754 y753))))
            (set! bound-identifier=?
              (lambda (x820 y819)
                (begin ((lambda (x822)
                          (if (not (nonsymbol-id?302 x822))
                              (error-hook129
                                'bound-identifier=?
                                '"invalid argument"
                                x822)
                              (void)))
                        x820)
                       ((lambda (x821)
                          (if (not (nonsymbol-id?302 x821))
                              (error-hook129
                                'bound-identifier=?
                                '"invalid argument"
                                x821)
                              (void)))
                        y819)
                       (bound-id=?399 x820 y819))))
            (set! literal-identifier=?
              (lambda (x758 y757)
                (begin ((lambda (x760)
                          (if (not (nonsymbol-id?302 x760))
                              (error-hook129
                                'literal-identifier=?
                                '"invalid argument"
                                x760)
                              (void)))
                        x758)
                       ((lambda (x759)
                          (if (not (nonsymbol-id?302 x759))
                              (error-hook129
                                'literal-identifier=?
                                '"invalid argument"
                                x759)
                              (void)))
                        y757)
                       (literal-id=?398 x758 y757))))
            (set! syntax-error
              (lambda (object814 . messages815)
                (begin (for-each
                         (lambda (x817)
                           ((lambda (x818)
                              (if (not (string? x818))
                                  (error-hook129
                                    'syntax-error
                                    '"invalid argument"
                                    x818)
                                  (void)))
                            x817))
                         messages815)
                       ((lambda (message816)
                          (error-hook129
                            '#f
                            message816
                            (strip464 object814 '(()))))
                        (if (null? messages815)
                            '"invalid syntax"
                            (apply string-append messages815))))))
            ((lambda ()
               (letrec ((match-each761
                         (lambda (e811 p809 w810)
                           (if (annotation?126 e811)
                               (match-each761
                                 (annotation-expression e811)
                                 p809
                                 w810)
                               (if (pair? e811)
                                   ((lambda (first812)
                                      (if first812
                                          ((lambda (rest813)
                                             (if rest813
                                                 (cons first812 rest813)
                                                 '#f))
                                           (match-each761
                                             (cdr e811)
                                             p809
                                             w810))
                                          '#f))
                                    (match767 (car e811) p809 w810 '()))
                                   (if (null? e811)
                                       '()
                                       (if (syntax-object?251 e811)
                                           (match-each761
                                             (syntax-object-expression252
                                               e811)
                                             p809
                                             (join-wraps390
                                               w810
                                               (syntax-object-wrap253
                                                 e811)))
                                           '#f))))))
                        (match-each+762
                         (lambda (e777
                                  x-pat772
                                  y-pat776
                                  z-pat773
                                  w775
                                  r774)
                           ((letrec ((f778
                                      (lambda (e780 w779)
                                        (if (pair? e780)
                                            (call-with-values
                                              (lambda ()
                                                (f778 (cdr e780) w779))
                                              (lambda (xr*783
                                                       y-pat781
                                                       r782)
                                                (if r782
                                                    (if (null? y-pat781)
                                                        ((lambda (xr784)
                                                           (if xr784
                                                               (values
                                                                 (cons xr784
                                                                       xr*783)
                                                                 y-pat781
                                                                 r782)
                                                               (values
                                                                 '#f
                                                                 '#f
                                                                 '#f)))
                                                         (match767
                                                           (car e780)
                                                           x-pat772
                                                           w779
                                                           '()))
                                                        (values
                                                          '()
                                                          (cdr y-pat781)
                                                          (match767
                                                            (car e780)
                                                            (car y-pat781)
                                                            w779
                                                            r782)))
                                                    (values '#f '#f '#f))))
                                            (if (annotation?126 e780)
                                                (f778 (annotation-expression
                                                        e780)
                                                      w779)
                                                (if (syntax-object?251
                                                      e780)
                                                    (f778 (syntax-object-expression252
                                                            e780)
                                                          (join-wraps390
                                                            w779
                                                            (syntax-object-wrap253
                                                              e780)))
                                                    (values
                                                      '()
                                                      y-pat776
                                                      (match767
                                                        e780
                                                        z-pat773
                                                        w779
                                                        r774))))))))
                              f778)
                            e777
                            w775)))
                        (match-each-any763
                         (lambda (e807 w806)
                           (if (annotation?126 e807)
                               (match-each-any763
                                 (annotation-expression e807)
                                 w806)
                               (if (pair? e807)
                                   ((lambda (l808)
                                      (if l808
                                          (cons (wrap404 (car e807) w806)
                                                l808)
                                          '#f))
                                    (match-each-any763 (cdr e807) w806))
                                   (if (null? e807)
                                       '()
                                       (if (syntax-object?251 e807)
                                           (match-each-any763
                                             (syntax-object-expression252
                                               e807)
                                             (join-wraps390
                                               w806
                                               (syntax-object-wrap253
                                                 e807)))
                                           '#f))))))
                        (match-empty764
                         (lambda (p786 r785)
                           (if (null? p786)
                               r785
                               (if (eq? p786 'any)
                                   (cons '() r785)
                                   (if (pair? p786)
                                       (match-empty764
                                         (car p786)
                                         (match-empty764 (cdr p786) r785))
                                       (if (eq? p786 'each-any)
                                           (cons '() r785)
                                           ((lambda (t787)
                                              (if (memv t787 '(each))
                                                  (match-empty764
                                                    (vector-ref p786 '1)
                                                    r785)
                                                  (if (memv t787 '(each+))
                                                      (match-empty764
                                                        (vector-ref
                                                          p786
                                                          '1)
                                                        (match-empty764
                                                          (reverse
                                                            (vector-ref
                                                              p786
                                                              '2))
                                                          (match-empty764
                                                            (vector-ref
                                                              p786
                                                              '3)
                                                            r785)))
                                                      (if (memv t787
                                                                '(free-id
                                                                   atom))
                                                          r785
                                                          (if (memv t787
                                                                    '(vector))
                                                              (match-empty764
                                                                (vector-ref
                                                                  p786
                                                                  '1)
                                                                r785)
                                                              (void))))))
                                            (vector-ref p786 '0))))))))
                        (combine765
                         (lambda (r*805 r804)
                           (if (null? (car r*805))
                               r804
                               (cons (map car r*805)
                                     (combine765 (map cdr r*805) r804)))))
                        (match*766
                         (lambda (e791 p788 w790 r789)
                           (if (null? p788)
                               (if (null? e791) r789 '#f)
                               (if (pair? p788)
                                   (if (pair? e791)
                                       (match767
                                         (car e791)
                                         (car p788)
                                         w790
                                         (match767
                                           (cdr e791)
                                           (cdr p788)
                                           w790
                                           r789))
                                       '#f)
                                   (if (eq? p788 'each-any)
                                       ((lambda (l792)
                                          (if l792 (cons l792 r789) '#f))
                                        (match-each-any763 e791 w790))
                                       ((lambda (t793)
                                          (if (memv t793 '(each))
                                              (if (null? e791)
                                                  (match-empty764
                                                    (vector-ref p788 '1)
                                                    r789)
                                                  ((lambda (r*794)
                                                     (if r*794
                                                         (combine765
                                                           r*794
                                                           r789)
                                                         '#f))
                                                   (match-each761
                                                     e791
                                                     (vector-ref p788 '1)
                                                     w790)))
                                              (if (memv t793 '(free-id))
                                                  (if (id?303 e791)
                                                      (if (literal-id=?398
                                                            (wrap404
                                                              e791
                                                              w790)
                                                            (vector-ref
                                                              p788
                                                              '1))
                                                          r789
                                                          '#f)
                                                      '#f)
                                                  (if (memv t793 '(each+))
                                                      (call-with-values
                                                        (lambda ()
                                                          (match-each+762
                                                            e791
                                                            (vector-ref
                                                              p788
                                                              '1)
                                                            (vector-ref
                                                              p788
                                                              '2)
                                                            (vector-ref
                                                              p788
                                                              '3)
                                                            w790
                                                            r789))
                                                        (lambda (xr*797
                                                                 y-pat795
                                                                 r796)
                                                          (if r796
                                                              (if (null?
                                                                    y-pat795)
                                                                  (if (null?
                                                                        xr*797)
                                                                      (match-empty764
                                                                        (vector-ref
                                                                          p788
                                                                          '1)
                                                                        r796)
                                                                      (combine765
                                                                        xr*797
                                                                        r796))
                                                                  '#f)
                                                              '#f)))
                                                      (if (memv t793
                                                                '(atom))
                                                          (if (equal?
                                                                (vector-ref
                                                                  p788
                                                                  '1)
                                                                (strip464
                                                                  e791
                                                                  w790))
                                                              r789
                                                              '#f)
                                                          (if (memv t793
                                                                    '(vector))
                                                              (if (vector?
                                                                    e791)
                                                                  (match767
                                                                    (vector->list
                                                                      e791)
                                                                    (vector-ref
                                                                      p788
                                                                      '1)
                                                                    w790
                                                                    r789)
                                                                  '#f)
                                                              (void)))))))
                                        (vector-ref p788 '0)))))))
                        (match767
                         (lambda (e801 p798 w800 r799)
                           (if (not r799)
                               '#f
                               (if (eq? p798 'any)
                                   (cons (wrap404 e801 w800) r799)
                                   (if (syntax-object?251 e801)
                                       (match*766
                                         ((lambda (e802)
                                            (if (annotation?126 e802)
                                                (annotation-expression
                                                  e802)
                                                e802))
                                          (syntax-object-expression252
                                            e801))
                                         p798
                                         (join-wraps390
                                           w800
                                           (syntax-object-wrap253 e801))
                                         r799)
                                       (match*766
                                         ((lambda (e803)
                                            (if (annotation?126 e803)
                                                (annotation-expression
                                                  e803)
                                                e803))
                                          e801)
                                         p798
                                         w800
                                         r799)))))))
                 (set! $syntax-dispatch
                   (lambda (e769 p768)
                     (if (eq? p768 'any)
                         (list e769)
                         (if (syntax-object?251 e769)
                             (match*766
                               ((lambda (e770)
                                  (if (annotation?126 e770)
                                      (annotation-expression e770)
                                      e770))
                                (syntax-object-expression252 e769))
                               p768
                               (syntax-object-wrap253 e769)
                               '())
                             (match*766
                               ((lambda (e771)
                                  (if (annotation?126 e771)
                                      (annotation-expression e771)
                                      e771))
                                e769)
                               p768
                               '(())
                               '()))))))))))))
($sc-put-cte
  'with-syntax
  (lambda (x1942)
    ((lambda (tmp1943)
       ((lambda (tmp1944)
          (if tmp1944
              (apply
                (lambda (_1947 e11945 e21946)
                  (cons '#(syntax-object begin ((top) #(ribcage #(_ e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                        (cons e11945 e21946)))
                tmp1944)
              ((lambda (tmp1949)
                 (if tmp1949
                     (apply
                       (lambda (_1954 out1950 in1953 e11951 e21952)
                         (list '#(syntax-object syntax-case ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                               in1953
                               '()
                               (list out1950
                                     (cons '#(syntax-object begin ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                           (cons e11951 e21952)))))
                       tmp1949)
                     ((lambda (tmp1956)
                        (if tmp1956
                            (apply
                              (lambda (_1961 out1957 in1960 e11958 e21959)
                                (list '#(syntax-object syntax-case ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                      (cons '#(syntax-object list ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                            in1960)
                                      '()
                                      (list out1957
                                            (cons '#(syntax-object begin ((top) #(ribcage #(_ out in e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                  (cons e11958 e21959)))))
                              tmp1956)
                            (syntax-error tmp1943)))
                      ($syntax-dispatch
                        tmp1943
                        '(any #(each (any any)) any . each-any)))))
               ($syntax-dispatch
                 tmp1943
                 '(any ((any any)) any . each-any)))))
        ($syntax-dispatch tmp1943 '(any () any . each-any))))
     x1942)))
($sc-put-cte
  'syntax-rules
  (lambda (x1965)
    ((lambda (tmp1966)
       ((lambda (tmp1967)
          (if tmp1967
              (apply
                (lambda (_1972 k1968 keyword1971 pattern1969 template1970)
                  (list '#(syntax-object lambda ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                        '#(syntax-object (x) ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                        (cons '#(syntax-object syntax-case ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                              (cons '#(syntax-object x ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                    (cons k1968
                                          (map (lambda (tmp1975 tmp1974)
                                                 (list (cons '#(syntax-object dummy ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                             tmp1974)
                                                       (list '#(syntax-object syntax ((top) #(ribcage #(_ k keyword pattern template) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                             tmp1975)))
                                               template1970
                                               pattern1969))))))
                tmp1967)
              (syntax-error tmp1966)))
        ($syntax-dispatch
          tmp1966
          '(any each-any . #(each ((any . any) any))))))
     x1965)))
($sc-put-cte
  'or
  (lambda (x1976)
    ((lambda (tmp1977)
       ((lambda (tmp1978)
          (if tmp1978
              (apply
                (lambda (_1979)
                  '#(syntax-object #f ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ()))))
                tmp1978)
              ((lambda (tmp1980)
                 (if tmp1980
                     (apply (lambda (_1982 e1981) e1981) tmp1980)
                     ((lambda (tmp1983)
                        (if tmp1983
                            (apply
                              (lambda (_1987 e11984 e21986 e31985)
                                (list '#(syntax-object let ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                      (list (list '#(syntax-object t ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                  e11984))
                                      (list '#(syntax-object if ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                            '#(syntax-object t ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                            '#(syntax-object t ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                            (cons '#(syntax-object or ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                  (cons e21986 e31985)))))
                              tmp1983)
                            (syntax-error tmp1977)))
                      ($syntax-dispatch
                        tmp1977
                        '(any any any . each-any)))))
               ($syntax-dispatch tmp1977 '(any any)))))
        ($syntax-dispatch tmp1977 '(any))))
     x1976)))
($sc-put-cte
  'and
  (lambda (x1989)
    ((lambda (tmp1990)
       ((lambda (tmp1991)
          (if tmp1991
              (apply
                (lambda (_1995 e11992 e21994 e31993)
                  (cons '#(syntax-object if ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                        (cons e11992
                              (cons (cons '#(syntax-object and ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                          (cons e21994 e31993))
                                    '#(syntax-object (#f) ((top) #(ribcage #(_ e1 e2 e3) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))))))
                tmp1991)
              ((lambda (tmp1997)
                 (if tmp1997
                     (apply (lambda (_1999 e1998) e1998) tmp1997)
                     ((lambda (tmp2000)
                        (if tmp2000
                            (apply
                              (lambda (_2001)
                                '#(syntax-object #t ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ()))))
                              tmp2000)
                            (syntax-error tmp1990)))
                      ($syntax-dispatch tmp1990 '(any)))))
               ($syntax-dispatch tmp1990 '(any any)))))
        ($syntax-dispatch tmp1990 '(any any any . each-any))))
     x1989)))
($sc-put-cte
  'let
  (lambda (x2002)
    ((lambda (tmp2003)
       ((lambda (tmp2004)
          (if (if tmp2004
                  (apply
                    (lambda (_2009 x2005 v2008 e12006 e22007)
                      (andmap identifier? x2005))
                    tmp2004)
                  '#f)
              (apply
                (lambda (_2015 x2011 v2014 e12012 e22013)
                  (cons (cons '#(syntax-object lambda ((top) #(ribcage #(_ x v e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                              (cons x2011 (cons e12012 e22013)))
                        v2014))
                tmp2004)
              ((lambda (tmp2019)
                 (if (if tmp2019
                         (apply
                           (lambda (_2025 f2020 x2024 v2021 e12023 e22022)
                             (andmap identifier? (cons f2020 x2024)))
                           tmp2019)
                         '#f)
                     (apply
                       (lambda (_2032 f2027 x2031 v2028 e12030 e22029)
                         (cons (list '#(syntax-object letrec ((top) #(ribcage #(_ f x v e1 e2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                     (list (list f2027
                                                 (cons '#(syntax-object lambda ((top) #(ribcage #(_ f x v e1 e2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                       (cons x2031
                                                             (cons e12030
                                                                   e22029)))))
                                     f2027)
                               v2028))
                       tmp2019)
                     (syntax-error tmp2003)))
               ($syntax-dispatch
                 tmp2003
                 '(any any #(each (any any)) any . each-any)))))
        ($syntax-dispatch
          tmp2003
          '(any #(each (any any)) any . each-any))))
     x2002)))
($sc-put-cte
  'let*
  (lambda (x2036)
    ((lambda (tmp2037)
       ((lambda (tmp2038)
          (if (if tmp2038
                  (apply
                    (lambda (let*2043 x2039 v2042 e12040 e22041)
                      (andmap identifier? x2039))
                    tmp2038)
                  '#f)
              (apply
                (lambda (let*2049 x2045 v2048 e12046 e22047)
                  ((letrec ((f2050
                             (lambda (bindings2051)
                               (if (null? bindings2051)
                                   (cons '#(syntax-object let ((top) #(ribcage () () ()) #(ribcage #(bindings) #((top)) #("i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(let* x v e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                         (cons '() (cons e12046 e22047)))
                                   ((lambda (tmp2053)
                                      ((lambda (tmp2054)
                                         (if tmp2054
                                             (apply
                                               (lambda (body2056
                                                        binding2055)
                                                 (list '#(syntax-object let ((top) #(ribcage #(body binding) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(bindings) #((top)) #("i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(let* x v e1 e2) #((top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                       (list binding2055)
                                                       body2056))
                                               tmp2054)
                                             (syntax-error tmp2053)))
                                       ($syntax-dispatch
                                         tmp2053
                                         '(any any))))
                                    (list (f2050 (cdr bindings2051))
                                          (car bindings2051)))))))
                     f2050)
                   (map list x2045 v2048)))
                tmp2038)
              (syntax-error tmp2037)))
        ($syntax-dispatch
          tmp2037
          '(any #(each (any any)) any . each-any))))
     x2036)))
($sc-put-cte
  'cond
  (lambda (x2059)
    ((lambda (tmp2060)
       ((lambda (tmp2061)
          (if tmp2061
              (apply
                (lambda (_2064 m12062 m22063)
                  ((letrec ((f2065
                             (lambda (clause2067 clauses2066)
                               (if (null? clauses2066)
                                   ((lambda (tmp2068)
                                      ((lambda (tmp2069)
                                         (if tmp2069
                                             (apply
                                               (lambda (e12071 e22070)
                                                 (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                       (cons e12071
                                                             e22070)))
                                               tmp2069)
                                             ((lambda (tmp2073)
                                                (if tmp2073
                                                    (apply
                                                      (lambda (e02074)
                                                        (cons '#(syntax-object let ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                              (cons (list (list '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                                e02074))
                                                                    '#(syntax-object ((if t t)) ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ()))))))
                                                      tmp2073)
                                                    ((lambda (tmp2075)
                                                       (if tmp2075
                                                           (apply
                                                             (lambda (e02077
                                                                      e12076)
                                                               (list '#(syntax-object let ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                     (list (list '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                                 e02077))
                                                                     (list '#(syntax-object if ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                           '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                           (cons e12076
                                                                                 '#(syntax-object (t) ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))))))
                                                             tmp2075)
                                                           ((lambda (tmp2078)
                                                              (if tmp2078
                                                                  (apply
                                                                    (lambda (e02081
                                                                             e12079
                                                                             e22080)
                                                                      (list '#(syntax-object if ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                            e02081
                                                                            (cons '#(syntax-object begin ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                                  (cons e12079
                                                                                        e22080))))
                                                                    tmp2078)
                                                                  ((lambda (_2083)
                                                                     (syntax-error
                                                                       x2059))
                                                                   tmp2068)))
                                                            ($syntax-dispatch
                                                              tmp2068
                                                              '(any any
                                                                    .
                                                                    each-any)))))
                                                     ($syntax-dispatch
                                                       tmp2068
                                                       '(any #(free-id
                                                               #(syntax-object => ((top) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ()))))
                                                             any)))))
                                              ($syntax-dispatch
                                                tmp2068
                                                '(any)))))
                                       ($syntax-dispatch
                                         tmp2068
                                         '(#(free-id
                                             #(syntax-object else ((top) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ()))))
                                            any
                                            .
                                            each-any))))
                                    clause2067)
                                   ((lambda (tmp2084)
                                      ((lambda (rest2085)
                                         ((lambda (tmp2086)
                                            ((lambda (tmp2087)
                                               (if tmp2087
                                                   (apply
                                                     (lambda (e02088)
                                                       (list '#(syntax-object let ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                             (list (list '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                         e02088))
                                                             (list '#(syntax-object if ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                   '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                   '#(syntax-object t ((top) #(ribcage #(e0) #((top)) #("i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                   rest2085)))
                                                     tmp2087)
                                                   ((lambda (tmp2089)
                                                      (if tmp2089
                                                          (apply
                                                            (lambda (e02091
                                                                     e12090)
                                                              (list '#(syntax-object let ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                    (list (list '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                                e02091))
                                                                    (list '#(syntax-object if ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                          '#(syntax-object t ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                          (cons e12090
                                                                                '#(syntax-object (t) ((top) #(ribcage #(e0 e1) #((top) (top)) #("i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ()))))
                                                                          rest2085)))
                                                            tmp2089)
                                                          ((lambda (tmp2092)
                                                             (if tmp2092
                                                                 (apply
                                                                   (lambda (e02095
                                                                            e12093
                                                                            e22094)
                                                                     (list '#(syntax-object if ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                           e02095
                                                                           (cons '#(syntax-object begin ((top) #(ribcage #(e0 e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                                 (cons e12093
                                                                                       e22094))
                                                                           rest2085))
                                                                   tmp2092)
                                                                 ((lambda (_2097)
                                                                    (syntax-error
                                                                      x2059))
                                                                  tmp2086)))
                                                           ($syntax-dispatch
                                                             tmp2086
                                                             '(any any
                                                                   .
                                                                   each-any)))))
                                                    ($syntax-dispatch
                                                      tmp2086
                                                      '(any #(free-id
                                                              #(syntax-object => ((top) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ()))))
                                                            any)))))
                                             ($syntax-dispatch
                                               tmp2086
                                               '(any))))
                                          clause2067))
                                       tmp2084))
                                    (f2065
                                      (car clauses2066)
                                      (cdr clauses2066)))))))
                     f2065)
                   m12062
                   m22063))
                tmp2061)
              (syntax-error tmp2060)))
        ($syntax-dispatch tmp2060 '(any any . each-any))))
     x2059)))
($sc-put-cte
  'do
  (lambda (orig-x2099)
    ((lambda (tmp2100)
       ((lambda (tmp2101)
          (if tmp2101
              (apply
                (lambda (_2108
                         var2102
                         init2107
                         step2103
                         e02106
                         e12104
                         c2105)
                  ((lambda (tmp2109)
                     ((lambda (tmp2119)
                        (if tmp2119
                            (apply
                              (lambda (step2120)
                                ((lambda (tmp2121)
                                   ((lambda (tmp2123)
                                      (if tmp2123
                                          (apply
                                            (lambda ()
                                              (list '#(syntax-object let ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                    '#(syntax-object doloop ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                    (map list
                                                         var2102
                                                         init2107)
                                                    (list '#(syntax-object if ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                          (list '#(syntax-object not ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                e02106)
                                                          (cons '#(syntax-object begin ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                (append
                                                                  c2105
                                                                  (list (cons '#(syntax-object doloop ((top) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                              step2120)))))))
                                            tmp2123)
                                          ((lambda (tmp2128)
                                             (if tmp2128
                                                 (apply
                                                   (lambda (e12130 e22129)
                                                     (list '#(syntax-object let ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                           '#(syntax-object doloop ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                           (map list
                                                                var2102
                                                                init2107)
                                                           (list '#(syntax-object if ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                 e02106
                                                                 (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                       (cons e12130
                                                                             e22129))
                                                                 (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                       (append
                                                                         c2105
                                                                         (list (cons '#(syntax-object doloop ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage #(step) #((top)) #("i")) #(ribcage #(_ var init step e0 e1 c) #((top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(orig-x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                                     step2120)))))))
                                                   tmp2128)
                                                 (syntax-error tmp2121)))
                                           ($syntax-dispatch
                                             tmp2121
                                             '(any . each-any)))))
                                    ($syntax-dispatch tmp2121 '())))
                                 e12104))
                              tmp2119)
                            (syntax-error tmp2109)))
                      ($syntax-dispatch tmp2109 'each-any)))
                   (map (lambda (v2113 s2112)
                          ((lambda (tmp2114)
                             ((lambda (tmp2115)
                                (if tmp2115
                                    (apply (lambda () v2113) tmp2115)
                                    ((lambda (tmp2116)
                                       (if tmp2116
                                           (apply
                                             (lambda (e2117) e2117)
                                             tmp2116)
                                           ((lambda (_2118)
                                              (syntax-error orig-x2099))
                                            tmp2114)))
                                     ($syntax-dispatch tmp2114 '(any)))))
                              ($syntax-dispatch tmp2114 '())))
                           s2112))
                        var2102
                        step2103)))
                tmp2101)
              (syntax-error tmp2100)))
        ($syntax-dispatch
          tmp2100
          '(any #(each (any any . any))
                (any . each-any)
                .
                each-any))))
     orig-x2099)))
($sc-put-cte
  'quasiquote
  (letrec ((isquote?2144
            (lambda (x2256)
              (if (identifier? x2256)
                  (free-identifier=?
                    x2256
                    '#(syntax-object quote ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()))))
                  '#f)))
           (islist?2136
            (lambda (x2150)
              (if (identifier? x2150)
                  (free-identifier=?
                    x2150
                    '#(syntax-object list ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()))))
                  '#f)))
           (iscons?2143
            (lambda (x2255)
              (if (identifier? x2255)
                  (free-identifier=?
                    x2255
                    '#(syntax-object cons ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()))))
                  '#f)))
           (quote-nil?2137
            (lambda (x2151)
              ((lambda (tmp2152)
                 ((lambda (tmp2153)
                    (if tmp2153
                        (apply
                          (lambda (quote?2154) (isquote?2144 quote?2154))
                          tmp2153)
                        ((lambda (_2155) '#f) tmp2152)))
                  ($syntax-dispatch tmp2152 '(any ()))))
               x2151)))
           (quasilist*2142
            (lambda (x2252 y2251)
              ((letrec ((f2253
                         (lambda (x2254)
                           (if (null? x2254)
                               y2251
                               (quasicons2138
                                 (car x2254)
                                 (f2253 (cdr x2254)))))))
                 f2253)
               x2252)))
           (quasicons2138
            (lambda (x2157 y2156)
              ((lambda (tmp2158)
                 ((lambda (tmp2159)
                    (if tmp2159
                        (apply
                          (lambda (x2161 y2160)
                            ((lambda (tmp2162)
                               ((lambda (tmp2163)
                                  (if (if tmp2163
                                          (apply
                                            (lambda (quote?2165 dy2164)
                                              (isquote?2144 quote?2165))
                                            tmp2163)
                                          '#f)
                                      (apply
                                        (lambda (quote?2167 dy2166)
                                          ((lambda (tmp2168)
                                             ((lambda (tmp2169)
                                                (if (if tmp2169
                                                        (apply
                                                          (lambda (quote?2171
                                                                   dx2170)
                                                            (isquote?2144
                                                              quote?2171))
                                                          tmp2169)
                                                        '#f)
                                                    (apply
                                                      (lambda (quote?2173
                                                               dx2172)
                                                        (list '#(syntax-object quote ((top) #(ribcage #(quote? dx) #((top) (top)) #("i" "i")) #(ribcage #(quote? dy) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                                              (cons dx2172
                                                                    dy2166)))
                                                      tmp2169)
                                                    ((lambda (_2174)
                                                       (if (null? dy2166)
                                                           (list '#(syntax-object list ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage #(quote? dy) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                                                 x2161)
                                                           (list '#(syntax-object cons ((top) #(ribcage #(_) #((top)) #("i")) #(ribcage #(quote? dy) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                                                 x2161
                                                                 y2160)))
                                                     tmp2168)))
                                              ($syntax-dispatch
                                                tmp2168
                                                '(any any))))
                                           x2161))
                                        tmp2163)
                                      ((lambda (tmp2175)
                                         (if (if tmp2175
                                                 (apply
                                                   (lambda (listp2177
                                                            stuff2176)
                                                     (islist?2136
                                                       listp2177))
                                                   tmp2175)
                                                 '#f)
                                             (apply
                                               (lambda (listp2179
                                                        stuff2178)
                                                 (cons '#(syntax-object list ((top) #(ribcage #(listp stuff) #((top) (top)) #("i" "i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                                       (cons x2161
                                                             stuff2178)))
                                               tmp2175)
                                             ((lambda (else2180)
                                                (list '#(syntax-object cons ((top) #(ribcage #(else) #((top)) #("i")) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                                      x2161
                                                      y2160))
                                              tmp2162)))
                                       ($syntax-dispatch
                                         tmp2162
                                         '(any . any)))))
                                ($syntax-dispatch tmp2162 '(any any))))
                             y2160))
                          tmp2159)
                        (syntax-error tmp2158)))
                  ($syntax-dispatch tmp2158 '(any any))))
               (list x2157 y2156))))
           (quasiappend2141
            (lambda (x2243 y2242)
              ((lambda (ls2244)
                 (if (null? ls2244)
                     '#(syntax-object (quote ()) ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(ls) #((top)) #("i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                     (if (null? (cdr ls2244))
                         (car ls2244)
                         ((lambda (tmp2245)
                            ((lambda (tmp2246)
                               (if tmp2246
                                   (apply
                                     (lambda (p2247)
                                       (cons '#(syntax-object append ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(ls) #((top)) #("i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x y) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                             p2247))
                                     tmp2246)
                                   (syntax-error tmp2245)))
                             ($syntax-dispatch tmp2245 'each-any)))
                          ls2244))))
               ((letrec ((f2249
                          (lambda (x2250)
                            (if (null? x2250)
                                (if (quote-nil?2137 y2242)
                                    '()
                                    (list y2242))
                                (if (quote-nil?2137 (car x2250))
                                    (f2249 (cdr x2250))
                                    (cons (car x2250)
                                          (f2249 (cdr x2250))))))))
                  f2249)
                x2243))))
           (quasivector2139
            (lambda (x2181)
              ((lambda (tmp2182)
                 ((lambda (pat-x2183)
                    ((lambda (tmp2184)
                       ((lambda (tmp2185)
                          (if (if tmp2185
                                  (apply
                                    (lambda (quote?2187 x2186)
                                      (isquote?2144 quote?2187))
                                    tmp2185)
                                  '#f)
                              (apply
                                (lambda (quote?2189 x2188)
                                  (list '#(syntax-object quote ((top) #(ribcage #(quote? x) #((top) (top)) #("i" "i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                        (list->vector x2188)))
                                tmp2185)
                              ((lambda (_2191)
                                 ((letrec ((f2192
                                            (lambda (x2194 k2193)
                                              ((lambda (tmp2195)
                                                 ((lambda (tmp2196)
                                                    (if (if tmp2196
                                                            (apply
                                                              (lambda (quote?2198
                                                                       x2197)
                                                                (isquote?2144
                                                                  quote?2198))
                                                              tmp2196)
                                                            '#f)
                                                        (apply
                                                          (lambda (quote?2200
                                                                   x2199)
                                                            (k2193
                                                              (map (lambda (tmp2201)
                                                                     (list '#(syntax-object quote ((top) #(ribcage #(quote? x) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x k) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_) #((top)) #("i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                                                           tmp2201))
                                                                   x2199)))
                                                          tmp2196)
                                                        ((lambda (tmp2202)
                                                           (if (if tmp2202
                                                                   (apply
                                                                     (lambda (listp2204
                                                                              x2203)
                                                                       (islist?2136
                                                                         listp2204))
                                                                     tmp2202)
                                                                   '#f)
                                                               (apply
                                                                 (lambda (listp2206
                                                                          x2205)
                                                                   (k2193
                                                                     x2205))
                                                                 tmp2202)
                                                               ((lambda (tmp2208)
                                                                  (if (if tmp2208
                                                                          (apply
                                                                            (lambda (cons?2211
                                                                                     x2209
                                                                                     y2210)
                                                                              (iscons?2143
                                                                                cons?2211))
                                                                            tmp2208)
                                                                          '#f)
                                                                      (apply
                                                                        (lambda (cons?2214
                                                                                 x2212
                                                                                 y2213)
                                                                          (f2192
                                                                            y2213
                                                                            (lambda (ls2215)
                                                                              (k2193
                                                                                (cons x2212
                                                                                      ls2215)))))
                                                                        tmp2208)
                                                                      ((lambda (else2216)
                                                                         (list '#(syntax-object list->vector ((top) #(ribcage #(else) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(x k) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_) #((top)) #("i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                                                               pat-x2183))
                                                                       tmp2195)))
                                                                ($syntax-dispatch
                                                                  tmp2195
                                                                  '(any any
                                                                        any)))))
                                                         ($syntax-dispatch
                                                           tmp2195
                                                           '(any .
                                                                 each-any)))))
                                                  ($syntax-dispatch
                                                    tmp2195
                                                    '(any each-any))))
                                               x2194))))
                                    f2192)
                                  x2181
                                  (lambda (ls2217)
                                    (cons '#(syntax-object vector ((top) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(ls) #((top)) #("i")) #(ribcage #(_) #((top)) #("i")) #(ribcage #(pat-x) #((top)) #("i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                          ls2217))))
                               tmp2184)))
                        ($syntax-dispatch tmp2184 '(any each-any))))
                     pat-x2183))
                  tmp2182))
               x2181)))
           (quasi2140
            (lambda (p2219 lev2218)
              ((lambda (tmp2220)
                 ((lambda (tmp2221)
                    (if tmp2221
                        (apply
                          (lambda (p2222)
                            (if (= lev2218 '0)
                                p2222
                                (quasicons2138
                                  '#(syntax-object (quote unquote) ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                  (quasi2140
                                    (list p2222)
                                    (- lev2218 '1)))))
                          tmp2221)
                        ((lambda (tmp2223)
                           (if tmp2223
                               (apply
                                 (lambda (p2225 q2224)
                                   (if (= lev2218 '0)
                                       (quasilist*2142
                                         p2225
                                         (quasi2140 q2224 lev2218))
                                       (quasicons2138
                                         (quasicons2138
                                           '#(syntax-object (quote unquote) ((top) #(ribcage #(p q) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                           (quasi2140
                                             p2225
                                             (- lev2218 '1)))
                                         (quasi2140 q2224 lev2218))))
                                 tmp2223)
                               ((lambda (tmp2228)
                                  (if tmp2228
                                      (apply
                                        (lambda (p2230 q2229)
                                          (if (= lev2218 '0)
                                              (quasiappend2141
                                                p2230
                                                (quasi2140 q2229 lev2218))
                                              (quasicons2138
                                                (quasicons2138
                                                  '#(syntax-object (quote unquote-splicing) ((top) #(ribcage #(p q) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                                  (quasi2140
                                                    p2230
                                                    (- lev2218 '1)))
                                                (quasi2140
                                                  q2229
                                                  lev2218))))
                                        tmp2228)
                                      ((lambda (tmp2233)
                                         (if tmp2233
                                             (apply
                                               (lambda (p2234)
                                                 (quasicons2138
                                                   '#(syntax-object (quote quasiquote) ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                                   (quasi2140
                                                     (list p2234)
                                                     (+ lev2218 '1))))
                                               tmp2233)
                                             ((lambda (tmp2235)
                                                (if tmp2235
                                                    (apply
                                                      (lambda (p2237 q2236)
                                                        (quasicons2138
                                                          (quasi2140
                                                            p2237
                                                            lev2218)
                                                          (quasi2140
                                                            q2236
                                                            lev2218)))
                                                      tmp2235)
                                                    ((lambda (tmp2238)
                                                       (if tmp2238
                                                           (apply
                                                             (lambda (x2239)
                                                               (quasivector2139
                                                                 (quasi2140
                                                                   x2239
                                                                   lev2218)))
                                                             tmp2238)
                                                           ((lambda (p2241)
                                                              (list '#(syntax-object quote ((top) #(ribcage #(p) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ())))
                                                                    p2241))
                                                            tmp2220)))
                                                     ($syntax-dispatch
                                                       tmp2220
                                                       '#(vector
                                                          each-any)))))
                                              ($syntax-dispatch
                                                tmp2220
                                                '(any . any)))))
                                       ($syntax-dispatch
                                         tmp2220
                                         '(#(free-id
                                             #(syntax-object quasiquote ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()))))
                                            any)))))
                                ($syntax-dispatch
                                  tmp2220
                                  '((#(free-id
                                       #(syntax-object unquote-splicing ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()))))
                                      .
                                      each-any)
                                    .
                                    any)))))
                         ($syntax-dispatch
                           tmp2220
                           '((#(free-id
                                #(syntax-object unquote ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()))))
                               .
                               each-any)
                             .
                             any)))))
                  ($syntax-dispatch
                    tmp2220
                    '(#(free-id
                        #(syntax-object unquote ((top) #(ribcage () () ()) #(ribcage #(p lev) #((top) (top)) #("i" "i")) #(ribcage #(isquote? islist? iscons? quote-nil? quasilist* quasicons quasiappend quasivector quasi) #((top) (top) (top) (top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i" "i" "i" "i")) #(ribcage (#(import-token *top*)) () ()))))
                       any))))
               p2219))))
    (lambda (x2145)
      ((lambda (tmp2146)
         ((lambda (tmp2147)
            (if tmp2147
                (apply (lambda (_2149 e2148) (quasi2140 e2148 '0)) tmp2147)
                (syntax-error tmp2146)))
          ($syntax-dispatch tmp2146 '(any any))))
       x2145))))
($sc-put-cte
  'include
  (lambda (x2257)
    (letrec ((read-file2258
              (lambda (fn2269 k2268)
                ((lambda (p2270)
                   ((letrec ((f2271
                              (lambda ()
                                ((lambda (x2272)
                                   (if (eof-object? x2272)
                                       (begin (close-input-port p2270) '())
                                       (cons (datum->syntax-object
                                               k2268
                                               x2272)
                                             (f2271))))
                                 (read p2270)))))
                      f2271)))
                 (open-input-file fn2269)))))
      ((lambda (tmp2259)
         ((lambda (tmp2260)
            (if tmp2260
                (apply
                  (lambda (k2262 filename2261)
                    ((lambda (fn2263)
                       ((lambda (tmp2264)
                          ((lambda (tmp2265)
                             (if tmp2265
                                 (apply
                                   (lambda (exp2266)
                                     (cons '#(syntax-object begin ((top) #(ribcage #(exp) #((top)) #("i")) #(ribcage () () ()) #(ribcage () () ()) #(ribcage #(fn) #((top)) #("i")) #(ribcage #(k filename) #((top) (top)) #("i" "i")) #(ribcage (read-file) ((top)) ("i")) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                           exp2266))
                                   tmp2265)
                                 (syntax-error tmp2264)))
                           ($syntax-dispatch tmp2264 'each-any)))
                        (read-file2258 fn2263 k2262)))
                     (syntax-object->datum filename2261)))
                  tmp2260)
                (syntax-error tmp2259)))
          ($syntax-dispatch tmp2259 '(any any))))
       x2257))))
($sc-put-cte
  'unquote
  (lambda (x2273)
    ((lambda (tmp2274)
       ((lambda (tmp2275)
          (if tmp2275
              (apply
                (lambda (_2277 e2276)
                  (syntax-error
                    x2273
                    '"expression not valid outside of quasiquote"))
                tmp2275)
              (syntax-error tmp2274)))
        ($syntax-dispatch tmp2274 '(any . each-any))))
     x2273)))
($sc-put-cte
  'unquote-splicing
  (lambda (x2278)
    ((lambda (tmp2279)
       ((lambda (tmp2280)
          (if tmp2280
              (apply
                (lambda (_2282 e2281)
                  (syntax-error
                    x2278
                    '"expression not valid outside of quasiquote"))
                tmp2280)
              (syntax-error tmp2279)))
        ($syntax-dispatch tmp2279 '(any . each-any))))
     x2278)))
($sc-put-cte
  'case
  (lambda (x2283)
    ((lambda (tmp2284)
       ((lambda (tmp2285)
          (if tmp2285
              (apply
                (lambda (_2289 e2286 m12288 m22287)
                  ((lambda (tmp2290)
                     ((lambda (body2317)
                        (list '#(syntax-object let ((top) #(ribcage #(body) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                              (list (list '#(syntax-object t ((top) #(ribcage #(body) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                          e2286))
                              body2317))
                      tmp2290))
                   ((letrec ((f2291
                              (lambda (clause2293 clauses2292)
                                (if (null? clauses2292)
                                    ((lambda (tmp2294)
                                       ((lambda (tmp2295)
                                          (if tmp2295
                                              (apply
                                                (lambda (e12297 e22296)
                                                  (cons '#(syntax-object begin ((top) #(ribcage #(e1 e2) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                        (cons e12297
                                                              e22296)))
                                                tmp2295)
                                              ((lambda (tmp2299)
                                                 (if tmp2299
                                                     (apply
                                                       (lambda (k2302
                                                                e12300
                                                                e22301)
                                                         (list '#(syntax-object if ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                               (list '#(syntax-object memv ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                     '#(syntax-object t ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                     (list '#(syntax-object quote ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                           k2302))
                                                               (cons '#(syntax-object begin ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                     (cons e12300
                                                                           e22301))))
                                                       tmp2299)
                                                     ((lambda (_2305)
                                                        (syntax-error
                                                          x2283))
                                                      tmp2294)))
                                               ($syntax-dispatch
                                                 tmp2294
                                                 '(each-any
                                                    any
                                                    .
                                                    each-any)))))
                                        ($syntax-dispatch
                                          tmp2294
                                          '(#(free-id
                                              #(syntax-object else ((top) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ()))))
                                             any
                                             .
                                             each-any))))
                                     clause2293)
                                    ((lambda (tmp2306)
                                       ((lambda (rest2307)
                                          ((lambda (tmp2308)
                                             ((lambda (tmp2309)
                                                (if tmp2309
                                                    (apply
                                                      (lambda (k2312
                                                               e12310
                                                               e22311)
                                                        (list '#(syntax-object if ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                              (list '#(syntax-object memv ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                    '#(syntax-object t ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                    (list '#(syntax-object quote ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                          k2312))
                                                              (cons '#(syntax-object begin ((top) #(ribcage #(k e1 e2) #((top) (top) (top)) #("i" "i" "i")) #(ribcage #(rest) #((top)) #("i")) #(ribcage () () ()) #(ribcage #(clause clauses) #((top) (top)) #("i" "i")) #(ribcage #(f) #((top)) #("i")) #(ribcage #(_ e m1 m2) #((top) (top) (top) (top)) #("i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                    (cons e12310
                                                                          e22311))
                                                              rest2307))
                                                      tmp2309)
                                                    ((lambda (_2315)
                                                       (syntax-error
                                                         x2283))
                                                     tmp2308)))
                                              ($syntax-dispatch
                                                tmp2308
                                                '(each-any
                                                   any
                                                   .
                                                   each-any))))
                                           clause2293))
                                        tmp2306))
                                     (f2291
                                       (car clauses2292)
                                       (cdr clauses2292)))))))
                      f2291)
                    m12288
                    m22287)))
                tmp2285)
              (syntax-error tmp2284)))
        ($syntax-dispatch tmp2284 '(any any any . each-any))))
     x2283)))
($sc-put-cte
  'identifier-syntax
  (lambda (x2318)
    ((lambda (tmp2319)
       ((lambda (tmp2320)
          (if tmp2320
              (apply
                (lambda (_2322 e2321)
                  (list '#(syntax-object lambda ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                        '#(syntax-object (x) ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                        (list '#(syntax-object syntax-case ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                              '#(syntax-object x ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                              '()
                              (list '#(syntax-object id ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                    '#(syntax-object (identifier? (syntax id)) ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                    (list '#(syntax-object syntax ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                          e2321))
                              (list (cons _2322
                                          '(#(syntax-object x ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                             #(syntax-object ... ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))))
                                    (list '#(syntax-object syntax ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                          (cons e2321
                                                '(#(syntax-object x ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                   #(syntax-object ... ((top) #(ribcage #(_ e) #((top) (top)) #("i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ()))))))))))
                tmp2320)
              ((lambda (tmp2323)
                 (if (if tmp2323
                         (apply
                           (lambda (_2329
                                    id2324
                                    exp12328
                                    var2325
                                    val2327
                                    exp22326)
                             (if (identifier? id2324)
                                 (identifier? var2325)
                                 '#f))
                           tmp2323)
                         '#f)
                     (apply
                       (lambda (_2335
                                id2330
                                exp12334
                                var2331
                                val2333
                                exp22332)
                         (list '#(syntax-object cons ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                               '#(syntax-object (quote macro!) ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                               (list '#(syntax-object lambda ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                     '#(syntax-object (x) ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                     (list '#(syntax-object syntax-case ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                           '#(syntax-object x ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                           '#(syntax-object (set!) ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                           (list (list '#(syntax-object set! ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                       var2331
                                                       val2333)
                                                 (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                       exp22332))
                                           (list (cons id2330
                                                       '(#(syntax-object x ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                          #(syntax-object ... ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))))
                                                 (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                       (cons exp12334
                                                             '(#(syntax-object x ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                                #(syntax-object ... ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))))))
                                           (list id2330
                                                 (list '#(syntax-object identifier? ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                       (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                             id2330))
                                                 (list '#(syntax-object syntax ((top) #(ribcage #(_ id exp1 var val exp2) #((top) (top) (top) (top) (top) (top)) #("i" "i" "i" "i" "i" "i")) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ())))
                                                       exp12334))))))
                       tmp2323)
                     (syntax-error tmp2319)))
               ($syntax-dispatch
                 tmp2319
                 '(any (any any)
                       ((#(free-id
                           #(syntax-object set! ((top) #(ribcage () () ()) #(ribcage #(x) #((top)) #("i")) #(ribcage (#(import-token *top*)) () ()))))
                          any
                          any)
                        any))))))
        ($syntax-dispatch tmp2319 '(any any))))
     x2318)))
