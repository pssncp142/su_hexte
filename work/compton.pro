PRO compton,beta,theta,x
  x = MAX_JUTT(beta,theta)
END

FUNCTION TRANSFER,

FUNCTION MAX_JUTT, beta, theta
  RETURN, REL_GAMMA(beta)^5*beta^2*EXP(-REL_GAMMA(beta)/theta)/ $
          (theta*BESELK(1/theta,2))
END

FUNCTION REL_GAMMA, beta
  RETURN, 1/SQRT(1-beta^2)
END
