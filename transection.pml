mtype {MSG, ACK}

/*channels for sending and receiving*/
chan toP1 = [2] of {mtype, int}
chan toP2 = [2] of {mtype, int}
chan toP3 = [2] of {mtype, int}
chan toClientRN = [10] of {int}
chan toClientP = [10] of {mtype, int, int}

typedef array { 
	chan aa[3]
};

array LOC[2];
LOC[0].aa[0] = toP1;
LOC[0].aa[1] = toP2;
LOC[0].aa[2] = toP3;
LOC[1].aa[0] = toClientRN;
LOC[1].aa[1] = toClientP;

/* participants */
proctype P1()
{
	int pnum = 1;
	chan in = LOC[0].aa[0];
	chan out = LOC[1].aa[1];
	bit recvbit;
	do
	:: in ? MSG(recvbit) ->
	   out ! ACK(pnum, recvbit);
	od
}

proctype P2()
{
	int pnum = 2;
	chan in = LOC[0].aa[1];
	chan out = LOC[1].aa[1];
	bit recvbit;
	do
	:: in ? MSG(recvbit) ->
	   out ! ACK(pnum, recvbit);
	od
}

proctype P3()
{
	int pnum = 3;
	chan in = LOC[0].aa[2];
	chan out = LOC[1].aa[1];
	bit recvbit;
	do
	:: in ? MSG(recvbit) ->
	   out ! ACK(pnum, recvbit);
	od
}

/*client*/
proctype Client()
{
	bit sendbit, info;
	int cnum, cindex, p;
    LOC[1].aa[0] ? cnum;
    
    int temp = cnum;
    do
    ::if
      ::temp >= 0 ->
            LOC[1].aa[0] ? cindex;
            LOC[0].aa[cindex] ! MSG, sendbit;
            temp--;
      ::else -> break
      fi
    od;

    int times = 0;
    do
    ::if
      ::times <= cnum -> 
             LOC[1].aa[1] ? ACK, p, info;
             times ++;
      ::else -> break;
      fi
	od          
}

/*random number generator*/
proctype Random_num (int upperbound)
{
	int nr;
    do
    :: nr++		                            /* randomly increment */
    :: nr--		                            /* or decrement       */
    :: nr >= 0 && nr < upperbound -> break	/* or stop            */
    od;

    LOC[1].aa[0]!nr;
}

init
{
    
    run Random_num(3);
    run Client();
    run P1();
    run P2();
	run P3();
}
