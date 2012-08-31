/* This does not work. The <args> does not seem to 
 * be intact when you have read it once and then passed
 * it on to a recursive call.
 */
Object
list(int n, ...)
{
    Object result;
    Object obj;
    va_list args;

    if (n <= 0) {
	result = makeNull();
    } else {
	va_start(args, n);
	obj = va_arg(args, Object);
	result = cons(obj, list(n-1, args));
	va_end(args);
    }

    return result;
}


