mtype{MSG}

chan toClient = [10] of {int, chan}
chan getRN = [20] of {int}

/*random number generator*/
proctype Random_num (int upperbound; chan RN)
{
	int nr;
    do
    :: nr >= upperbound -> nr = 0
    :: nr < 0 -> nr=upperbound -1
    :: nr++		                                /* randomly increment */
    :: nr--		                                /* or decrement       */
    :: nr >= 0 && nr < upperbound -> RN ! nr	/* or output            */
    od;
}

/*participants*/

proctype P1(chan RN, out)
{
    int rn;
    chan in = [10] of {mtype, bit};
    do
    ::bit recebit; 
	  RN ? rn;
	  out ! rn, in;
      in ? MSG(recebit);
    od
}

proctype P2(chan RN, out)
{
    int rn;
    chan in = [10] of {mtype, bit};
    do
    ::bit recebit; 
	  RN ? rn;
	  out ! rn, in;
      in ? MSG(recebit);
    od
}

proctype P3(chan RN, out)
{
    int rn;
    chan in = [10] of {mtype, bit};
    do
    ::bit recebit; 
	  RN ? rn;
	  out ! rn, in;
      in ? MSG(recebit);
    od
}

/*Client*/

proctype Client(chan RN, in)
{
    int rn;
    int sSet;
    bit sendbit; 
	RN ? rn;
	RN ? sSet;

	int match;
	chan toSend;
    do
    ::if
      ::sSet >= 0 ->
	    do
	    ::in? match, toSend ->
	        if
	        ::match == rn -> break
	        ::else
	        fi
	    od;
	    toSend ! MSG(sendbit);
	    sSet--;
	  ::else -> break;
	  fi
	od
}

/*main function*/

init{
	run Random_num (2, getRN);
	run P1(getRN, toClient);
	run P2(getRN, toClient);
	run P3(getRN, toClient);
	run Client(getRN, toClient);
}



