*********************'
Object
envLookup(Environment* env, char* var)
{
    Binding* binding;

    if (env == NULL)
	eprintf("envLookup: variable not found: %s\n", var);

    binding = htLookup(env->ht, var, 0, 0);
    if (binding == NULL)
	return envLookup(env->enclosingEnv, var);
    else
	return binding->value;
}

Environment*
envExtend(Environment* baseEnv, Object variables, Object values)
{
}

void
envDefine(Environment* env, char* var, Object value)
{
    Binding* binding;

    if (env == NULL)
	eprintf("envDefine: empty environment, variable: %s\n",
		var);

    binding = htLookup(env->ht, var, 1, value);
    binding->value = value;
}


void
envSet(Environment* env, char* var, Object value)
{
    Binding* binding;

    if (env == NULL)
	eprintf("envDefine: empty environment, variable %s\n",
		var);

    binding = htLookup(env->ht, var, 0, 0);
    if (binding == NULL)
	eprintf("envSet: unbound variable: %s\n", var);
    else
	binding->value = value;
}


Environment*
envCreate(Environment* enclosingEnv)
{
    Environment* env = (Environment*)emalloc(sizeof(Environment));

    env->ht = htCreate();
    env->enclosingEnv = enclosingEnv;

    return env;
}

void
envFree(Environment* env)
{
    htFree(env->ht);
    free(env);
}
