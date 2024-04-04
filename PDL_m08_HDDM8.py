#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#-----
# Model 8: Full HDDM

# Based on the functions and tutorial scripts available online at:
# https://hddm.readthedocs.io/en/latest/
#-----


# In[1]:


import pandas as pd
import numpy as np
import hddm
from scipy import stats
import seaborn as sns
import matplotlib.pyplot as plt
import pymc
import kabuki
sns.set(style="white")
get_ipython().run_line_magic('matplotlib', 'inline')
from tqdm import tqdm
import warnings
warnings.filterwarnings("ignore", category=np.VisibleDeprecationWarning)


# In[2]:


data = pd.read_csv("PDL_data_discrimination_all.csv", sep = ";")
data.head()


# In[3]:


data = hddm.utils.flip_errors(data)

fig = plt.figure()
ax = fig.add_subplot(111, xlabel = 'RT', ylabel = 'count', title = 'RT distribution')
for i, subj_data in data.groupby('subj_idx'):
    subj_data.rt.hist(bins = 20, histtype = 'step', ax = ax)
    
    plt.savefig('Reactions times Pooled.pdf')


# In[4]:


from kabuki.analyze import gelman_rubin

models = []
for i in range (3):
    DDM8 = hddm.HDDM(data, depends_on = {'a': ['stim', 'reward'], 't': ['stim','reward'], 'v': ['stim','reward']}, p_outlier = 0.05, bias = False)
    DDM8.find_starting_values()
    DDM8.sample(20000, burn = 15000, dbname = 'traces.db', db = 'pickle')
    models.append(DDM8)
    
np.max(list(gelman_rubin(models).values()))


# In[5]:


M8_concat = kabuki.utils.concat_models(models)


# In[6]:


M8_concat.plot_posteriors(['a'])


# In[7]:


M8_concat.plot_posteriors(['t'])


# In[8]:


M8_concat.plot_posteriors(['v'])


# In[9]:


M8_concat.print_stats()


# In[10]:


M08_traces = M8_concat.get_traces()


# In[11]:


M08_traces.to_csv(r'C:\Users\Hubsc\OneDrive\Desktop\RepositoryPRIMAS1\HDDM8_Draws.csv', index = False, header = True, sep = ';')


# In[12]:


#-----
# PPC(s)
ppc_data = hddm.utils.post_pred_gen(M8_concat)


# In[14]:


hddm.utils.post_pred_stats(data, ppc_data)


# In[ ]:


# ---------
# Posterior inferences


# In[13]:


# MODEL NODES =================================================================================================================#
#Drift rates v
v_CRcontrol, v_CRdifficult, v_CReasy = M8_concat.nodes_db.node[['v(CR.control)', 'v(CR.difficult)', 'v(CR.easy)']]
v_NCcontrol, v_NCdifficult, v_NCeasy = M8_concat.nodes_db.node[['v(NC.control)', 'v(NC.difficult)', 'v(NC.easy)']]
v_NRcontrol, v_NRdifficult, v_NReasy = M8_concat.nodes_db.node[['v(NR.control)', 'v(NR.difficult)', 'v(NR.easy)']]

#Boundary separation a
a_CRcontrol, a_CRdifficult, a_CReasy = M8_concat.nodes_db.node[['a(CR.control)', 'a(CR.difficult)', 'a(CR.easy)']]
a_NCcontrol, a_NCdifficult, a_NCeasy = M8_concat.nodes_db.node[['a(NC.control)', 'a(NC.difficult)', 'a(NC.easy)']]
a_NRcontrol, a_NRdifficult, a_NReasy = M8_concat.nodes_db.node[['a(NR.control)', 'a(NR.difficult)', 'a(NR.easy)']]

#Non-decision times t
t_CRcontrol, t_CRdifficult, t_CReasy = M8_concat.nodes_db.node[['t(CR.control)', 't(CR.difficult)', 't(CR.easy)']]
t_NCcontrol, t_NCdifficult, t_NCeasy = M8_concat.nodes_db.node[['t(NC.control)', 't(NC.difficult)', 't(NC.easy)']]
t_NRcontrol, t_NRdifficult, t_NReasy = M8_concat.nodes_db.node[['t(NR.control)', 't(NR.difficult)', 't(NR.easy)']]


# In[ ]:


# DIFFERENCE AMONGST PULSE CONDITIONS =====


# In[ ]:


# DRIFT RATES -----


# In[14]:


# In control trials (+0°C)

hddm.analyze.plot_posterior_nodes([v_CRcontrol, v_NCcontrol, v_NRcontrol])
plt.xlabel('Drift Rate')
plt.ylabel('Posterior Probability')
plt.title('Drift rates amongst control trials')    
plt.savefig('Model8_Drift_Rates_Control.pdf')  


# In[15]:


print ("Control Trials: P(V Contingent > V Non-Contingent)", (v_CRcontrol.trace() > v_NCcontrol.trace()).mean())
print ("Control Trials: P(V Contingent > V No-Reward)", (v_CRcontrol.trace() > v_NRcontrol.trace()).mean())
print ("Control Trials: P(V Non-Contingent > V No-Reward)", (v_NCcontrol.trace() > v_NRcontrol.trace()).mean())


# In[16]:


print ("Control Trials: P(V Contingent < V Non-Contingent)", (v_CRcontrol.trace() < v_NCcontrol.trace()).mean())
print ("Control Trials: P(V Contingent < V No-Reward)", (v_CRcontrol.trace() < v_NRcontrol.trace()).mean())
print ("Control Trials: P(V Non-Contingent < V No-Reward)", (v_NCcontrol.trace() < v_NRcontrol.trace()).mean())


# In[17]:


# In difficult trials (+0.2°C)

hddm.analyze.plot_posterior_nodes([v_CRdifficult, v_NCdifficult, v_NRdifficult])
plt.xlabel('Drift Rate')
plt.ylabel('Posterior Probability')
plt.title('Drift rates amongst difficult trials')
plt.savefig('Model8_Drift_Rates_Difficult.pdf')  


# In[18]:


print ("Difficult Trials: P(V Contingent > V Non-Contingent)", (v_CRdifficult.trace() > v_NCdifficult.trace()).mean())
print ("Difficult Trials: P(V Contingent > V No-Reward)", (v_CRdifficult.trace() > v_NRdifficult.trace()).mean())
print ("Difficult Trials: P(V Non-Contingent > V No-Reward)", (v_NCdifficult.trace() > v_NRdifficult.trace()).mean())


# In[19]:


print ("Difficult Trials: P(V Contingent < V Non-Contingent)", (v_CRdifficult.trace() < v_NCdifficult.trace()).mean())
print ("Difficult Trials: P(V Contingent < V No-Reward)", (v_CRdifficult.trace() < v_NRdifficult.trace()).mean())
print ("Difficult Trials: P(V Non-Contingent < V No-Reward)", (v_NCdifficult.trace() < v_NRdifficult.trace()).mean())


# In[20]:


#In easy trials (+0.4°C)

hddm.analyze.plot_posterior_nodes([v_CReasy, v_NCeasy, v_NReasy])
plt.xlabel('Drift Rate')
plt.ylabel('Posterior Probability')
plt.title('Drift rates amongst easy trials')
plt.savefig('Model8_Drift_Rates_Easy.pdf') 


# In[21]:


print ("Easy Trials: P(V Contingent > V Non-Contingent)", (v_CReasy.trace() > v_NCeasy.trace()).mean())
print ("Easy Trials: P(V Contingent > V No-Reward)", (v_CReasy.trace() > v_NReasy.trace()).mean())
print ("Easy Trials: P(V Non-Contingent > V No-Reward)", (v_NCeasy.trace() > v_NReasy.trace()).mean())


# In[22]:


print ("Easy Trials: P(V Contingent < V Non-Contingent)", (v_CReasy.trace() < v_NCeasy.trace()).mean())
print ("Easy Trials: P(V Contingent < V No-Reward)", (v_CReasy.trace() < v_NReasy.trace()).mean())
print ("Easy Trials: P(V Non-Contingent < V No-Reward)", (v_NCeasy.trace() < v_NReasy.trace()).mean())


# In[ ]:


# BOUNDARY SEPARATIONS -----


# In[23]:


# In control trials (+0°C)

hddm.analyze.plot_posterior_nodes([a_CRcontrol, a_NCcontrol, a_NRcontrol])
plt.xlabel('Boundary Separation')
plt.ylabel('Posterior Probability')
plt.title('Bounderies amongst control trials')
plt.savefig('Model8_Bounderies_Control.pdf') 


# In[24]:


print ("Control Trials: P(A Contingent > A Non-Contingent)", (a_CRcontrol.trace() > a_NCcontrol.trace()).mean())
print ("Control Trials: P(A Contingent > A No-Reward)", (a_CRcontrol.trace() > a_NRcontrol.trace()).mean())
print ("Control Trials: P(A Non-Contingent > A No-Reward)", (a_NCcontrol.trace() > a_NRcontrol.trace()).mean())


# In[25]:


print ("Control Trials: P(A Contingent < A Non-Contingent)", (a_CRcontrol.trace() < a_NCcontrol.trace()).mean())
print ("Control Trials: P(A Contingent < A No-Reward)", (a_CRcontrol.trace() < a_NRcontrol.trace()).mean())
print ("Control Trials: P(A Non-Contingent < A No-Reward)", (a_NCcontrol.trace() < a_NRcontrol.trace()).mean())


# In[26]:


# In difficult trials (+0.2°C)

hddm.analyze.plot_posterior_nodes([a_CRdifficult, a_NCdifficult, a_NRdifficult])
plt.xlabel('Boundary Separation')
plt.ylabel('Posterior Probability')
plt.title('Bounderies amongst difficult trials')
plt.savefig('Model8_Bounderies_Difficult.pdf') 


# In[27]:


print ("Difficult Trials: P(A Contingent > A Non-Contingent)", (a_CRdifficult.trace() > a_NCdifficult.trace()).mean())
print ("Difficult Trials: P(A Contingent > A No-Reward)", (a_CRdifficult.trace() > a_NRdifficult.trace()).mean())
print ("Difficult Trials: P(A Non-Contingent > A No-Reward)", (a_NCdifficult.trace() > a_NRdifficult.trace()).mean())


# In[28]:


print ("Difficult Trials: P(A Contingent < A Non-Contingent)", (a_CRdifficult.trace() < a_NCdifficult.trace()).mean())
print ("Difficult Trials: P(A Contingent < A No-Reward)", (a_CRdifficult.trace() < a_NRdifficult.trace()).mean())
print ("Difficult Trials: P(A Non-Contingent < A No-Reward)", (a_NCdifficult.trace() < a_NRdifficult.trace()).mean())


# In[29]:


# In easy trials (+0.4°C)

hddm.analyze.plot_posterior_nodes([a_CReasy, a_NCeasy, a_NReasy])
plt.xlabel('Boundary Separation')
plt.ylabel('Posterior Probability')
plt.title('Bounderies amongst easy trials')
plt.savefig('Model8_Bounderies_Easy.pdf')


# In[30]:


print ("Easy Trials: P(A Contingent > A Non-Contingent)", (a_CReasy.trace() > a_NCeasy.trace()).mean())
print ("Easy Trials: P(A Contingent > A No-Reward)", (a_CReasy.trace() > a_NReasy.trace()).mean())
print ("Easy Trials: P(A Non-Contingent > A No-Reward)", (a_NCeasy.trace() > a_NReasy.trace()).mean())


# In[31]:


print ("Easy Trials: P(A Contingent < A Non-Contingent)", (a_CReasy.trace() < a_NCeasy.trace()).mean())
print ("Easy Trials: P(A Contingent < A No-Reward)", (a_CReasy.trace() < a_NReasy.trace()).mean())
print ("Easy Trials: P(A Non-Contingent < A No-Reward)", (a_NCeasy.trace() < a_NReasy.trace()).mean())


# In[ ]:


# NON-DECISION TIMES -----


# In[32]:


# In control trials (+0°C)

hddm.analyze.plot_posterior_nodes([t_CRcontrol, t_NCcontrol, t_NRcontrol])
plt.xlabel('Non-Decision Times')
plt.ylabel('Posterior Probability')
plt.title('Non-decision times amongst control trials')
plt.savefig('Model8_TER_Control.pdf')


# In[33]:


print ("Control Trials: P(ter Contingent > ter Non-Contingent)", (t_CRcontrol.trace() > t_NCcontrol.trace()).mean())
print ("Control Trials: P(ter Contingent > ter No-Reward)", (t_CRcontrol.trace() > t_NRcontrol.trace()).mean())
print ("Control Trials: P(ter Non-Contingent > ter No-Reward)", (t_NCcontrol.trace() > t_NRcontrol.trace()).mean())


# In[34]:


print ("Control Trials: P(ter Contingent < ter Non-Contingent)", (t_CRcontrol.trace() < t_NCcontrol.trace()).mean())
print ("Control Trials: P(ter Contingent < ter No-Reward)", (t_CRcontrol.trace() < t_NRcontrol.trace()).mean())
print ("Control Trials: P(ter Non-Contingent < ter No-Reward)", (t_NCcontrol.trace() < t_NRcontrol.trace()).mean())


# In[35]:


# In difficult trials (+0.2°C)

hddm.analyze.plot_posterior_nodes([t_CRdifficult, t_NCdifficult, t_NRdifficult])
plt.xlabel('Non-Decision Times')
plt.ylabel('Posterior Probability')
plt.title('Non-decision times amongst difficult trials') 
plt.savefig('Model8_TER_Difficult.pdf') 


# In[36]:


print ("Difficult Trials: P(ter Contingent > ter Non-Contingent)", (t_CRdifficult.trace() > t_NCdifficult.trace()).mean())
print ("Difficult Trials: P(ter Contingent > ter No-Reward)", (t_CRdifficult.trace() > t_NRdifficult.trace()).mean())
print ("Difficult Trials: P(ter Non-Contingent > ter No-Reward)", (t_NCdifficult.trace() > t_NRdifficult.trace()).mean())


# In[37]:


print ("Difficult Trials: P(ter Contingent < ter Non-Contingent)", (t_CRdifficult.trace() < t_NCdifficult.trace()).mean())
print ("Difficult Trials: P(ter Contingent < ter No-Reward)", (t_CRdifficult.trace() < t_NRdifficult.trace()).mean())
print ("Difficult Trials: P(ter Non-Contingent < ter No-Reward)", (t_NCdifficult.trace() < t_NRdifficult.trace()).mean())


# In[38]:


# In easy trials (+0.4°C)

hddm.analyze.plot_posterior_nodes([t_CReasy, t_NCeasy, t_NReasy])
plt.xlabel('Non-Decision Times')
plt.ylabel('Posterior Probability')
plt.title('Non-decision times amongst easy trials')
plt.savefig('Model8_TER_Easy.pdf') 


# In[39]:


print ("Easy Trials: P(ter Contingent > ter Non-Contingent)", (t_CReasy.trace() > t_NCeasy.trace()).mean())
print ("Easy Trials: P(ter Contingent > ter No-Reward)", (t_CReasy.trace() > t_NReasy.trace()).mean())
print ("Easy Trials: P(ter Non-Contingent > ter No-Reward)", (t_NCeasy.trace() > t_NReasy.trace()).mean())


# In[40]:


print ("Easy Trials: P(ter Contingent < ter Non-Contingent)", (t_CReasy.trace() < t_NCeasy.trace()).mean())
print ("Easy Trials: P(ter Contingent < ter No-Reward)", (t_CReasy.trace() < t_NReasy.trace()).mean())
print ("Easy Trials: P(ter Non-Contingent < ter No-Reward)", (t_NCeasy.trace() < t_NReasy.trace()).mean())


# In[ ]:


# DIFFERENCE AMONGST PULSE CONDITIONS =======


# In[ ]:


# DRIFT RATES ------


# In[41]:


# In no reward trials

hddm.analyze.plot_posterior_nodes([v_NRcontrol, v_NRdifficult, v_NReasy])
plt.xlabel('Drift Rate')
plt.ylabel('Posterior Probability')
plt.title('Drift rates amongst No Reward trials')    
plt.savefig('Model8_Drift_Rates_NoReward.pdf') 


# In[42]:


print ("No-Reward Trials: P(V Control > V Easy)", (v_NRcontrol.trace() > v_NReasy.trace()).mean())
print ("No-Reward Trials: P(V Control > V Difficult)", (v_NRcontrol.trace() > v_NRdifficult.trace()).mean())
print ("No-Reward Trials: P(V Easy > V Difficult)", (v_NReasy.trace() > v_NRdifficult.trace()).mean())


# In[43]:


print ("No-Reward Trials: P(V Control < V Easy)", (v_NRcontrol.trace() < v_NReasy.trace()).mean())
print ("No-Reward Trials: P(V Control < V Difficult)", (v_NRcontrol.trace() < v_NRdifficult.trace()).mean())
print ("No-Reward Trials: P(V Easy < V Difficult)", (v_NReasy.trace() < v_NRdifficult.trace()).mean())


# In[44]:


# In contingent trials

hddm.analyze.plot_posterior_nodes([v_CRcontrol, v_CRdifficult, v_CReasy])
plt.xlabel('Drift Rate')
plt.ylabel('Posterior Probability')
plt.title('Drift rates amongst contingent trials')    
plt.savefig('Model8_Drift_Rates_Contingent.pdf') 


# In[45]:


print ("Contingent Trials: P(V Control > V Easy)", (v_CRcontrol.trace() > v_CReasy.trace()).mean())
print ("Contingent Trials: P(V Control > V Difficult)", (v_CRcontrol.trace() > v_CRdifficult.trace()).mean())
print ("Contingent Trials: P(V Easy > V Difficult)", (v_CReasy.trace() > v_CRdifficult.trace()).mean())


# In[46]:


print ("Contingent Trials: P(V Control < V Easy)", (v_CRcontrol.trace() < v_CReasy.trace()).mean())
print ("Contingent Trials: P(V Control < V Difficult)", (v_CRcontrol.trace() < v_CRdifficult.trace()).mean())
print ("Contingent Trials: P(V Easy < V Difficult)", (v_CReasy.trace() < v_CRdifficult.trace()).mean())


# In[47]:


# In non-contingent trials

hddm.analyze.plot_posterior_nodes([v_NCcontrol, v_NCdifficult, v_NCeasy])
plt.xlabel('Drift Rate')
plt.ylabel('Posterior Probability')
plt.title('Drift rates amongst non-contingent trials')    
plt.savefig('Model8_Drift_Rates_NonContingent.pdf')   


# In[48]:


print ("Non-Contingent Trials: P(V Control > V Easy)", (v_NCcontrol.trace() > v_NCeasy.trace()).mean())
print ("Non-Contingent Trials: P(V Control > V Difficult)", (v_NCcontrol.trace() > v_NCdifficult.trace()).mean())
print ("Non-Contingent Trials: P(V Easy > V Difficult)", (v_NCeasy.trace() > v_NCdifficult.trace()).mean())


# In[49]:


print ("Non-Contingent Trials: P(V Control < V Easy)", (v_NCcontrol.trace() < v_NCeasy.trace()).mean())
print ("Non-Contingent Trials: P(V Control < V Difficult)", (v_NCcontrol.trace() < v_NCdifficult.trace()).mean())
print ("Non-Contingent Trials: P(V Easy < V Difficult)", (v_NCeasy.trace() < v_NCdifficult.trace()).mean())


# In[ ]:


# BOUNDARY SEPARATIONS -----


# In[50]:


# In no reward trials

hddm.analyze.plot_posterior_nodes([a_NRcontrol, a_NRdifficult, a_NReasy])
plt.xlabel('Boundary separation')
plt.ylabel('Posterior Probability')
plt.title('Boundary separations amongst No Reward trials')    
plt.savefig('Model8_Bounderies_NoReward.pdf')  


# In[51]:


print ("No-Reward Trials: P(A Control > A Easy)", (a_NRcontrol.trace() > a_NReasy.trace()).mean())
print ("No-Reward Trials: P(A Control > A Difficult)", (a_NRcontrol.trace() > a_NRdifficult.trace()).mean())
print ("No-Reward Trials: P(A Easy > A Difficult)", (a_NReasy.trace() > a_NRdifficult.trace()).mean())


# In[52]:


print ("No-Reward Trials: P(A Control < A Easy)", (a_NRcontrol.trace() < a_NReasy.trace()).mean())
print ("No-Reward Trials: P(A Control < A Difficult)", (a_NRcontrol.trace() < a_NRdifficult.trace()).mean())
print ("No-Reward Trials: P(A Easy < A Difficult)", (a_NReasy.trace() < a_NRdifficult.trace()).mean())


# In[53]:


# In contingent trials

hddm.analyze.plot_posterior_nodes([a_CRcontrol, a_CRdifficult, a_CReasy])
plt.xlabel('Boundary separation')
plt.ylabel('Posterior Probability')
plt.title('Boundary separations amongst contingent trials')    
plt.savefig('Model8_Bounderies_Contingent.pdf')


# In[54]:


print ("Contingent Trials: P(A Control > A Easy)", (a_CRcontrol.trace() > a_CReasy.trace()).mean())
print ("Contingent Trials: P(A Control > A Difficult)", (a_CRcontrol.trace() > a_CRdifficult.trace()).mean())
print ("Contingent Trials: P(A Easy > A Difficult)", (a_CReasy.trace() > a_CRdifficult.trace()).mean())


# In[55]:


print ("Contingent Trials: P(A Control < A Easy)", (a_CRcontrol.trace() < a_CReasy.trace()).mean())
print ("Contingent Trials: P(A Control < A Difficult)", (a_CRcontrol.trace() < a_CRdifficult.trace()).mean())
print ("Contingent Trials: P(A Easy < A Difficult)", (a_CReasy.trace() < a_CRdifficult.trace()).mean())


# In[56]:


# In non-contingent trials

hddm.analyze.plot_posterior_nodes([a_NCcontrol, a_NCdifficult, a_NCeasy])
plt.xlabel('Boundary separation')
plt.ylabel('Posterior Probability')
plt.title('Boundary separations amongst non-contingent trials')    
plt.savefig('Model8_Bounderies_NonContingent.pdf')  


# In[57]:


print ("Non-contingent Trials: P(A Control > A Easy)", (a_NCcontrol.trace() > a_NCeasy.trace()).mean())
print ("Non-contingent Trials: P(A Control > A Difficult)", (a_NCcontrol.trace() > a_NCdifficult.trace()).mean())
print ("Non-contingent Trials: P(A Easy > A Difficult)", (a_NCeasy.trace() > a_NCdifficult.trace()).mean())


# In[58]:


print ("Non-contingent Trials: P(A Control < A Easy)", (a_NCcontrol.trace() < a_NCeasy.trace()).mean())
print ("Non-contingent Trials: P(A Control < A Difficult)", (a_NCcontrol.trace() < a_NCdifficult.trace()).mean())
print ("Non-contingent Trials: P(A Easy < A Difficult)", (a_NCeasy.trace() < a_NCdifficult.trace()).mean())


# In[ ]:


# NON-DECISION TIMES ------


# In[59]:


# In no rewards trials

hddm.analyze.plot_posterior_nodes([t_NRcontrol, t_NRdifficult, t_NReasy])
plt.xlabel('Non Decision times')
plt.ylabel('Posterior Probability')
plt.title('Non-decision times amongst No Reward trials')    
plt.savefig('Model8_Ters_NoReward.pdf') 


# In[60]:


print ("No-Reward Trials: P(T Control > T Easy)", (t_NRcontrol.trace() > t_NReasy.trace()).mean())
print ("No-Reward Trials: P(T Control > T Difficult)", (t_NRcontrol.trace() > t_NRdifficult.trace()).mean())
print ("No-Reward Trials: P(T Easy > T Difficult)", (t_NReasy.trace() > t_NRdifficult.trace()).mean())


# In[61]:


print ("No-Reward Trials: P(T Control < T Easy)", (t_NRcontrol.trace() < t_NReasy.trace()).mean())
print ("No-Reward Trials: P(T Control < T Difficult)", (t_NRcontrol.trace() < t_NRdifficult.trace()).mean())
print ("No-Reward Trials: P(T Easy < T Difficult)", (t_NReasy.trace() < t_NRdifficult.trace()).mean())


# In[62]:


# In contingent trials

hddm.analyze.plot_posterior_nodes([t_CRcontrol, t_CRdifficult, t_CReasy])
plt.xlabel('Non Decision times')
plt.ylabel('Posterior Probability')
plt.title('Non-decision times amongst Contingent trials')    
plt.savefig('Model8_Ters_Contingent.pdf')


# In[63]:


print ("Contingent Trials: P(T Control > T Easy)", (t_CRcontrol.trace() > t_CReasy.trace()).mean())
print ("Contingent Trials: P(T Control > T Difficult)", (t_CRcontrol.trace() > t_CRdifficult.trace()).mean())
print ("Contingent Trials: P(T Easy > T Difficult)", (t_CReasy.trace() > t_CRdifficult.trace()).mean())


# In[64]:


print ("Contingent Trials: P(T Control < T Easy)", (t_CRcontrol.trace() < t_CReasy.trace()).mean())
print ("Contingent Trials: P(T Control < T Difficult)", (t_CRcontrol.trace() < t_CRdifficult.trace()).mean())
print ("Contingent Trials: P(T Easy < T Difficult)", (t_CReasy.trace() < t_CRdifficult.trace()).mean())


# In[65]:


# In non-contingent trials

hddm.analyze.plot_posterior_nodes([t_NCcontrol, t_NCdifficult, t_NCeasy])
plt.xlabel('Non Decision times')
plt.ylabel('Posterior Probability')
plt.title('Non-decision times amongst Non Contingent') 
plt.savefig('Model8_Ters_NonContingent.pdf')


# In[66]:


print ("Non-contingent Trials: P(T Control > T Easy)", (t_NCcontrol.trace() > t_NCeasy.trace()).mean())
print ("Non-contingent Trials: P(T Control > T Difficult)", (t_NCcontrol.trace() > t_NCdifficult.trace()).mean())
print ("Non-contingent Trials: P(T Easy > T Difficult)", (t_NCeasy.trace() > t_NCdifficult.trace()).mean())


# In[67]:


print ("Non-contingent Trials: P(T Control < T Easy)", (t_NCcontrol.trace() < t_NCeasy.trace()).mean())
print ("Non-contingent Trials: P(T Control < T Difficult)", (t_NCcontrol.trace() < t_NCdifficult.trace()).mean())
print ("Non-contingent Trials: P(T Easy < T Difficult)", (t_NCeasy.trace() < t_NCdifficult.trace()).mean())


# In[ ]:


#------

