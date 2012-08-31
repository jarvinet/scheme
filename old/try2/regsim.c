

/* Reads:
 *  "text"   the program text
 * Writes:
 *  "insts"  the instruction sequecence of the program text
 *  "labels" the labels of the program text
 */
void extractLabels(void)
{
    Object inst;

    while (!isNull(getReg(regText))) {
	if (isSymbol(car(getReg(regText)))) {
	    append(regLabels, cons(car(getReg(regText)),
				   cdr(getReg(regText))));
	} else {
	    append(regInsts, car(getReg(regText)));
	}
	setReg(regText, cdr(getReg(regText)));
    }
}
