#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#-----
# Model 1: stim dependant parameters only

# Based on the functions and tutorial scripts available online at:
# https://hddm.readthedocs.io/en/latest/
#-----


# In[6]:


#import
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


# In[7]:


data = pd.read_csv("PDL_data_discrimination_all.csv", sep = ";")
data.head()


# In[8]:


data = hddm.utils.flip_errors(data)

fig = plt.figure()
ax = fig.add_subplot(111, xlabel = 'RT', ylabel = 'count', title = 'RT distribution')
for i, subj_data in data.groupby('subj_idx'):
    subj_data.rt.hist(bins = 20, histtype = 'step', ax = ax)
    
    plt.savefig('Reactions times Pooled.pdf')


# In[10]:


from kabuki.analyze import gelman_rubin

models = []
for i in range (3):
    DDM1 = hddm.HDDM(data, depends_on = {'a': ['stim'], 't': ['stim'], 'v': ['stim']}, p_outlier = 0.05, bias = False)
    DDM1.find_starting_values()
    DDM1.sample(20000, burn = 15000, dbname = 'traces.db', db = 'pickle')
    models.append(DDM1)
    
np.max(list(gelman_rubin(models).values()))


# In[11]:


M1_concat = kabuki.utils.concat_models(models)


# In[12]:


M1_concat.plot_posteriors(['a'])


# In[13]:


M1_concat.plot_posteriors(['t'])


# In[14]:


M1_concat.plot_posteriors(['v'])


# In[17]:


M1_concat.print_stats()


# In[18]:


M01_traces = M1_concat.get_traces()


# In[19]:


M01_traces.to_csv(r'C:\Users\Hubsc\OneDrive\Desktop\RepositoryPRIMAS1\HDDM1_Draws.csv', index = False, header = True, sep = ';')


# In[20]:


#-----
# PPC(s)
ppc_data = hddm.utils.post_pred_gen(M1_concat)


# In[21]:


hddm.utils.post_pred_stats(data, ppc_data)

