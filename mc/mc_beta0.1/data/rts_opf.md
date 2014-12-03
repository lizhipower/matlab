MATPOWER Version 4.1, 14-Dec-2011 -- AC Optimal Power Flow
MATLAB Interior Point Solver -- MIPS, Version 1.0, 07-Feb-2011
Converged!

Converged in 0.38 seconds
Objective Function Value = -2850.00 $/hr
================================================================================
|     System Summary                                                           |
================================================================================

How many?                How much?              P (MW)            Q (MVAr)
---------------------    -------------------  -------------  -----------------
Buses             24     Total Gen Capacity    3405.0        -535.0 to 1776.0
Generators        33     On-line Capacity      3405.0        -535.0 to 1776.0
Committed Gens    33     Generation (actual)   2885.9             487.5
Loads             17     Load                  2850.0             580.0
  Fixed            0       Fixed                  0.0               0.0
  Dispatchable    17       Dispatchable        2850.0 of 2850.0   580.0
Shunts             1     Shunt (inj)             -0.0            -100.2
Branches          38     Losses (I^2 * Z)        35.87            340.66
Transformers       5     Branch Charging (inj)     -              533.3
Inter-ties        10     Total Inter-tie Flow  1186.1             162.2
Areas              4

                          Minimum                      Maximum
                 -------------------------  --------------------------------
Voltage Magnitude   0.964 p.u. @ bus 24         1.025 p.u. @ bus 22
Voltage Angle     -16.51 deg   @ bus 6         11.36 deg   @ bus 22
P Losses (I^2*R)             -                  3.80 MW    @ line 12-23
Q Losses (I^2*X)             -                 29.63 MVAr  @ line 12-23
Lambda P            0.00 $/MWh @ bus 22         0.00 $/MWh @ bus 6
Lambda Q           -0.00 $/MWh @ bus 7          0.00 $/MWh @ bus 24

================================================================================
|     Bus Data                                                                 |
================================================================================
 Bus      Voltage          Generation             Load          Lambda($/MVA-hr)
  #   Mag(pu) Ang(deg)   P (MW)   Q (MVAr)   P (MW)   Q (MVAr)     P        Q
----- ------- --------  --------  --------  --------  --------  -------  -------
    1  1.018  -12.074    163.52     13.74    108.00*    22.00*    0.000     -
    2  1.018  -12.123    164.25     13.68     97.00*    20.00*    0.000     -
    3  0.976  -11.637       -         -      180.00*    37.00*    0.000     -
    4  0.986  -14.126       -         -       74.00*    15.00*    0.000     -
    5  1.005  -14.311       -         -       71.00*    14.00*    0.000     -
    6  1.001  -16.514       -         -      136.00*    28.00*    0.000     -
    7  1.025  -12.232    230.64     59.58    125.00*    25.00*    0.000     -
    8  0.989  -15.584       -         -      171.00*    35.00*    0.000     -
    9  0.993  -11.500       -         -      175.00*    36.00*    0.000     -
   10  1.019  -13.287       -         -      195.00*    40.00*    0.000     -
   11  0.991   -5.518       -         -         -         -       0.000     -
   12  0.989   -4.215       -         -         -         -       0.000     -
   13  1.012    0.000*   520.17    113.17    265.00*    54.00*    0.000     -
   14  1.000   -3.737      0.00    100.24    194.00*    39.00*    0.000     -
   15  0.993    2.846    167.82     40.65    317.00*    64.00*    0.000     -
   16  0.998    2.455    131.81     14.34    100.00*    20.00*    0.000     -
   17  1.006    5.939       -         -         -         -       0.000     -
   18  1.008    7.119    373.10     37.33    333.00*    68.00*    0.000     -
   19  0.998    2.067       -         -      181.00*    37.00*    0.000     -
   20  1.008    3.741       -         -      128.00*    26.00*    0.000     -
   21  1.012    7.860    375.47     41.55       -         -       0.000     -
   22  1.025   11.357    188.56      1.82       -         -       0.000     -
   23  1.018    5.399    570.52     51.45       -         -       0.000     -
   24  0.964   -2.474       -         -         -         -       0.000     -
                        --------  --------  --------  --------
               Total:   2885.87    487.55   2850.00    580.00

================================================================================
|     Branch Data                                                              |
================================================================================
Brnch   From   To    From Bus Injection   To Bus Injection     Loss (I^2 * Z)
  #     Bus    Bus    P (MW)   Q (MVAr)   P (MW)   Q (MVAr)   P (MW)   Q (MVAr)
-----  -----  -----  --------  --------  --------  --------  --------  --------
   1      1      2      5.77    -27.66     -5.76    -20.10     0.001      0.01
   2      1      3      1.56     16.92     -1.35    -21.79     0.210      0.81
   3      1      5     48.20      2.48    -47.71     -2.92     0.492      1.91
   4      2      4     32.37     16.38    -31.93    -18.14     0.436      1.68
   5      2      6     40.65     -2.61    -39.85      0.37     0.792      3.06
   6      3      9     -5.35    -14.70      5.41     11.84     0.065      0.25
   7      3     24   -173.31     -0.50    174.08     28.60     0.770     28.09
   8      4      9    -42.07      3.14     42.56     -3.98     0.494      1.91
   9      5     10    -23.29    -11.08     23.44      9.19     0.144      0.56
  10      6     10    -96.15   -128.54     97.43   -116.71     1.287      5.60
  11      7      8    105.64     34.58   -103.76    -29.00     1.881      7.26
  12      8      9    -40.01      6.89     40.74     -8.44     0.735      2.84
  13      8     10    -27.23    -12.90     27.61      9.84     0.374      1.45
  14      9     11   -119.23    -20.68    119.59     33.89     0.362     13.21
  15      9     12   -144.49    -14.74    145.01     33.77     0.522     19.03
  16     10     11   -158.76     25.36    159.35     -3.64     0.596     21.72
  17     10     12   -184.72     32.32    185.53     -2.77     0.810     29.56
  18     11     13   -203.78    -14.31    206.36     24.48     2.587     20.19
  19     11     14    -75.17    -15.94     75.49      9.70     0.318      2.46
  20     12     13   -157.55    -28.30    159.13     30.66     1.584     12.36
  21     12     23   -172.99     -2.70    176.79     11.91     3.804     29.63
  22     13     23   -110.33      4.04    111.67    -12.34     1.338     10.42
  23     14     16   -269.49     51.54    273.27    -30.25     3.786     29.45
  24     15     16     35.18    -32.59    -35.13     29.37     0.049      0.38
  25     15     21   -180.33    -13.07    182.41     18.90     2.081     16.19
  26     15     21   -180.33    -13.07    182.41     18.90     2.081     16.19
  27     15     24    176.30     35.38   -174.08    -28.60     2.224     17.23
  28     16     17   -235.03      1.40    236.87      7.50     1.832     14.38
  29     16     19     28.70     -6.18    -28.68      1.54     0.025      0.19
  30     17     18   -144.13      5.53    144.50     -5.64     0.370      2.96
  31     17     22    -92.74    -13.03     93.88     -0.84     1.147      8.95
  32     18     21    -52.20    -12.52     52.29      7.67     0.092      0.72
  33     18     21    -52.20    -12.52     52.29      7.67     0.092      0.72
  34     19     20    -76.16    -19.27     76.47     13.29     0.309      2.40
  35     19     20    -76.16    -19.27     76.47     13.29     0.309      2.40
  36     20     23   -140.47    -26.29    141.03     25.94     0.560      4.32
  37     20     23   -140.47    -26.29    141.03     25.94     0.560      4.32
  38     21     22    -93.93    -11.60     94.68      2.66     0.751      5.85
                                                             --------  --------
                                                    Total:    35.868    340.66

================================================================================
|     Generation Constraints                                                   |
================================================================================
 Gen   Bus                Active Power Limits
  #     #    Pmin mu    Pmin       Pg       Pmax    Pmax mu
----  -----  -------  --------  --------  --------  -------
  15    14    0.000      0.00       -        0.00    0.000

================================================================================
|     Dispatchable Load Constraints                                            |
================================================================================
Gen  Bus               Active Power Limits
 #    #   Pmin mu    Pmin       Pg       Pmax    Pmax mu
---  ---  -------  --------  --------  --------  -------
 34    1   0.503   -108.00   -108.00      0.00      -
 35    2   0.503    -97.00    -97.00      0.00      -
 36    3   0.530   -180.00   -180.00      0.00      -
 37    4   0.499    -74.00    -74.00      0.00      -
 38    5   0.495    -71.00    -71.00      0.00      -
 39    6   0.638   -136.00   -136.00      0.00      -
 40    7   0.501   -125.00   -125.00      0.00      -
 41    8   0.501   -171.00   -171.00      0.00      -
 42    9   0.501   -175.00   -175.00      0.00      -
 43   10   0.502   -195.00   -195.00      0.00      -
 44   13   0.500   -265.00   -265.00      0.00      -
 45   14   0.499   -194.00   -194.00      0.00      -
 46   15   0.499   -317.00   -317.00      0.00      -
 47   16   0.500   -100.00   -100.00      0.00      -
 48   18   0.499   -333.00   -333.00      0.00      -
 49   19   0.499   -181.00   -181.00      0.00      -
 50   20   0.500   -128.00   -128.00      0.00      -

Gen  Bus              Reactive Power Limits
 #    #   Qmin mu    Qmin       Qg       Qmax    Qmax mu
---  ---  -------  --------  --------  --------  -------
 34    1   2.438    -22.00    -22.00      0.00      -
 35    2   2.410    -20.00    -20.00      0.00      -
 36    3   2.287    -37.00    -37.00      0.00      -
 37    4   2.472    -15.00    -15.00      0.00      -
 38    5   2.563    -14.00    -14.00      0.00      -
 39    6   1.758    -28.00    -28.00      0.00      -
 40    7   2.494    -25.00    -25.00      0.00      -
 41    8   2.436    -35.00    -35.00      0.00      -
 42    9   2.427    -36.00    -36.00      0.00      -
 43   10   2.430    -40.00    -40.00      0.00      -
 44   13   2.454    -54.00    -54.00      0.00      -
 45   14   2.494    -39.00    -39.00      0.00      -
 46   15   2.481    -64.00    -64.00      0.00      -
 47   16   2.498    -20.00    -20.00      0.00      -
 48   18   2.456    -68.00    -68.00      0.00      -
 49   19   2.451    -37.00    -37.00      0.00      -
 50   20   2.461    -26.00    -26.00      0.00      -

result =

    version: '2'
    baseMVA: 100
        bus: [24x17 double]
        gen: [50x25 double]
     branch: [38x21 double]
      areas: [4x2 double]
    gencost: [50x7 double]
      order: [1x1 struct]
         om: [1x1 opf_model]
          x: [148x1 double]
         mu: [1x1 struct]
          f: -2.8500e+03
        var: [1x1 struct]
        lin: [1x1 struct]
        nln: [1x1 struct]
         et: 0.3770
    success: 1
        raw: [1x1 struct]