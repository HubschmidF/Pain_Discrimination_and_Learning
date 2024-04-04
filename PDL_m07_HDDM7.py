#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#-----
# Model 7: reward dependent boundaries and drift rates

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
    DDM7 = hddm.HDDM(data, depends_on = {'a': ['stim', 'reward'], 't': ['stim'], 'v': ['stim', 'reward']}, p_outlier = 0.05, bias = False)
    DDM7.find_starting_values()
    DDM7.sample(20000, burn = 15000, dbname = 'traces.db', db = 'pickle')
    models.append(DDM7)
    
np.max(list(gelman_rubin(models).values()))


# In[5]:


M7_concat = kabuki.utils.concat_models(models)


# In[6]:


M7_concat.plot_posteriors(['a'])


# In[7]:


M7_concat.plot_posteriors(['t'])


# In[8]:


M7_concat.plot_posteriors(['v'])


# In[9]:


M7_concat.print_stats()


# In[10]:


M07_traces = M7_concat.get_traces()


# In[11]:


M07_traces.to_csv(r'C:\Users\Hubsc\OneDrive\Desktop\RepositoryPRIMAS1\HDDM7_Draws.csv', index = False, header = True, sep = ';')


# In[12]:


#-----
# PPC(s)
ppc_data = hddm.utils.post_pred_gen(M7_concat)


# In[13]:


hddm.utils.post_pred_stats(data, ppc_data)


# In[ ]:


#-----

