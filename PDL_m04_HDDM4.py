#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#-----
# Model 4: reward dependent boundaries

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
    DDM4 = hddm.HDDM(data, depends_on = {'a': ['stim', 'reward'], 't': ['stim'], 'v': ['stim']}, p_outlier = 0.05, bias = False)
    DDM4.find_starting_values()
    DDM4.sample(20000, burn = 15000, dbname = 'traces.db', db = 'pickle')
    models.append(DDM4)
    
np.max(list(gelman_rubin(models).values()))


# In[5]:


M4_concat = kabuki.utils.concat_models(models)


# In[6]:


M4_concat.plot_posteriors(['a'])


# In[7]:


M4_concat.plot_posteriors(['t'])


# In[8]:


M4_concat.plot_posteriors(['v'])


# In[9]:


M4_concat.print_stats()


# In[10]:


M04_traces = M4_concat.get_traces()


# In[11]:


M04_traces.to_csv(r'C:\Users\Hubsc\OneDrive\Desktop\RepositoryPRIMAS1\HDDM4_Draws.csv', index = False, header = True, sep = ';')


# In[12]:


#-----
# PPC(s)
ppc_data = hddm.utils.post_pred_gen(M4_concat)


# In[13]:


hddm.utils.post_pred_stats(data, ppc_data)


# In[ ]:


#------

