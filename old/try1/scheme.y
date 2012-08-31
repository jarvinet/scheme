

object	: list
        | symbol
        | string
        | number
        | null
        ;

list    : '(' pairs ')'
        ;

pairs   : pair pairs
        | pair
        ;

pair    : object '.' object
        ;



()
(foo)            (foo . ())
(foo bar baz)    (foo . (bar . (baz .())))
(foo bar . baz)  (foo . (bar . baz))





