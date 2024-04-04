#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#-----
# Model 5: reward dependent non-decision times and drift rates

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
    DDM5 = hddm.HDDM(data, depends_on = {'a': ['stim'], 't': ['stim','reward'], 'v': ['stim','reward']}, p_outlier = 0.05, bias = False)
    DDM5.find_starting_values()
    DDM5.sample(20000, burn = 15000, dbname = 'traces.db', db = 'pickle')
    models.append(DDM5)
    
np.max(list(gelman_rubin(models).values()))


# In[5]:


M5_concat = kabuki.utils.concat_models(models)


# In[6]:


M5_concat.plot_posteriors(['a'])


# In[7]:


M5_concat.plot_posteriors(['t'])


# In[8]:


M5_concat.plot_posteriors(['v'])


# In[9]:


M5_concat.print_stats()


# In[10]:


M05_traces = M5_concat.get_traces()


# In[11]:


M05_traces.to_csv(r'C:\Users\Hubsc\OneDrive\Desktop\RepositoryPRIMAS1\HDDM5_Draws.csv', index = False, header = True, sep = ';')


# In[12]:


#-----
# PPC(s)
ppc_data = hddm.utils.post_pred_gen(M5_concat)


# In[13]:


hddm.utils.post_pred_stats(data, ppc_data)


# In[ ]:



