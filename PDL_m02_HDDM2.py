#!/usr/bin/env python
# coding: utf-8

# In[2]:


#-----
# Model 2: reward dependent drift rates

# Based on the functions and tutorial scripts available online at:
# https://hddm.readthedocs.io/en/latest/
#-----


# In[1]:


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


# In[3]:


data = pd.read_csv("PDL_data_discrimination_all.csv", sep = ";")
data.head()


# In[4]:


data = hddm.utils.flip_errors(data)

fig = plt.figure()
ax = fig.add_subplot(111, xlabel = 'RT', ylabel = 'count', title = 'RT distribution')
for i, subj_data in data.groupby('subj_idx'):
    subj_data.rt.hist(bins = 20, histtype = 'step', ax = ax)
    
    plt.savefig('Reactions times Pooled.pdf')


# In[5]:


from kabuki.analyze import gelman_rubin

models = []
for i in range (3):
    DDM2 = hddm.HDDM(data, depends_on = {'a': ['stim'], 't': ['stim'], 'v': ['stim', 'reward']}, p_outlier = 0.05, bias = False)
    DDM2.find_starting_values()
    DDM2.sample(20000, burn = 15000, dbname = 'traces.db', db = 'pickle')
    models.append(DDM2)
    
np.max(list(gelman_rubin(models).values()))


# In[6]:


M2_concat = kabuki.utils.concat_models(models)


# In[7]:


M2_concat.plot_posteriors(['a'])


# In[8]:


M2_concat.plot_posteriors(['t'])


# In[9]:


M2_concat.plot_posteriors(['v'])


# In[11]:


M2_concat.print_stats()


# In[12]:


M02_traces = M2_concat.get_traces()


# In[14]:


M02_traces.to_csv(r'C:\Users\Hubsc\OneDrive\Desktop\RepositoryPRIMAS1\HDDM2_Draws.csv', index = False, header = True, sep = ';')


# In[15]:


#-----
# PPC(s)
ppc_data = hddm.utils.post_pred_gen(M2_concat)


# In[16]:


hddm.utils.post_pred_stats(data, ppc_data)


# In[ ]:


#-------

