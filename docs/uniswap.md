## **How Uniswap Works & Token Pricing in Liquidity Pools**

### **Introduction**
- Uniswap is a decentralized exchange (DEX) that allows users to swap cryptocurrencies without relying on a traditional order book.
- It uses an **Automated Market Maker (AMM)** model, where liquidity providers deposit tokens into pools, and prices are determined algorithmically.

### Constant Product Formula 
```
(x * y = k)
```
At the core of Uniswap is the **Constant Product Formula**:

![image](https://hackmd.io/_uploads/HJNFTGiYJx.png)


This formula ensures that liquidity is **always available**, but the **price adjusts dynamically** based on supply and demand.



### **How Token Prices Are Determined**
The **price of a token** is based on the ratio of tokens in the pool:

![image](https://hackmd.io/_uploads/HJznaMjF1x.png)


If someone swaps **1 ETH for USDC**, the new balance must satisfy: 
```
    x * y = k
```


### **Price Slippage**
Since \( k \) remains constant, trades shift the token ratio, **changing the price**. A large trade moves the price **more significantly** (higher slippage).

**Example:**
- If a trader swaps **10 ETH** for USDC, the ETH in the pool decreases, so the price of ETH increases.
- This discourages single large trades and incentivizes spreading out orders.


### **Liquidity Provider & Fees**
- Liquidity providers (LPs) deposit **equal value** of both tokens.
- They **earn fees** (e.g., 0.3% per swap) distributed proportionally to their share in the pool.
- If token prices change significantly, LPs may face **impermanent loss** (a temporary loss in value compared to just holding the tokens).


### **Graphical Illustration**
Here is a visual representation of how the **Constant Product Formula** affects price changes when swapping tokens. The curve illustrates the **price impact of trades** as token ratios change.

![image](https://hackmd.io/_uploads/SkIMAGoKye.png)

The graph above illustrates **Uniswap's constant product formula**. The curve shows how the **ETH-USDC ratio changes** when ETH is swapped for USDC or vice versa.

### **Observations:**
1. **Initial Pool Balance**: (100 ETH, 10,000 USDC) is marked in **red**.
2. **Swapping ETH for USDC**:
   - If ETH increases in the pool (e.g., 110 ETH, marked in **green**), the USDC amount decreases.
   - This results in a **lower ETH price**.
3. **Swapping USDC for ETH**:
   - If ETH decreases in the pool (e.g., 90 ETH, marked in **purple**), the USDC amount increases.
   - This results in a **higher ETH price**.

The curve ensures that **as one token becomes scarcer, its price increases**. This is how **Uniswap dynamically adjusts token prices based on demand**.


### **Conclusion**
- **No order book**: Prices adjust automatically using \( x \cdot y = k \).
- **Larger trades cause more slippage**: The further you move on the curve, the greater the price impact.
- **Liquidity providers earn fees** but face impermanent loss.

---

### Traditional Order Book
![image](https://hackmd.io/_uploads/BJii0MjKkg.png)

## **How Uniswap Works & Token Pricing in Liquidity Pools**

### **Introduction**
- Uniswap is a decentralized exchange (DEX) that allows users to swap cryptocurrencies without relying on a traditional order book.
- It uses an **Automated Market Maker (AMM)** model, where liquidity providers deposit tokens into pools, and prices are determined algorithmically.

### Constant Product Formula 
```
(x * y = k)
```
At the core of Uniswap is the **Constant Product Formula**:

![image](https://hackmd.io/_uploads/HJNFTGiYJx.png)


This formula ensures that liquidity is **always available**, but the **price adjusts dynamically** based on supply and demand.



### **How Token Prices Are Determined**
The **price of a token** is based on the ratio of tokens in the pool:

![image](https://hackmd.io/_uploads/HJznaMjF1x.png)


If someone swaps **1 ETH for USDC**, the new balance must satisfy: 
```
    x * y = k
```


### **Price Slippage**
Since \( k \) remains constant, trades shift the token ratio, **changing the price**. A large trade moves the price **more significantly** (higher slippage).

**Example:**
- If a trader swaps **10 ETH** for USDC, the ETH in the pool decreases, so the price of ETH increases.
- This discourages single large trades and incentivizes spreading out orders.


### **Liquidity Provider & Fees**
- Liquidity providers (LPs) deposit **equal value** of both tokens.
- They **earn fees** (e.g., 0.3% per swap) distributed proportionally to their share in the pool.
- If token prices change significantly, LPs may face **impermanent loss** (a temporary loss in value compared to just holding the tokens).


### **Graphical Illustration**
Here is a visual representation of how the **Constant Product Formula** affects price changes when swapping tokens. The curve illustrates the **price impact of trades** as token ratios change.

![image](https://hackmd.io/_uploads/SkIMAGoKye.png)

The graph above illustrates **Uniswap's constant product formula**. The curve shows how the **ETH-USDC ratio changes** when ETH is swapped for USDC or vice versa.

### **Observations:**
1. **Initial Pool Balance**: (100 ETH, 10,000 USDC) is marked in **red**.
2. **Swapping ETH for USDC**:
   - If ETH increases in the pool (e.g., 110 ETH, marked in **green**), the USDC amount decreases.
   - This results in a **lower ETH price**.
3. **Swapping USDC for ETH**:
   - If ETH decreases in the pool (e.g., 90 ETH, marked in **purple**), the USDC amount increases.
   - This results in a **higher ETH price**.

The curve ensures that **as one token becomes scarcer, its price increases**. This is how **Uniswap dynamically adjusts token prices based on demand**.


### **Conclusion**
- **No order book**: Prices adjust automatically using \( x \cdot y = k \).
- **Larger trades cause more slippage**: The further you move on the curve, the greater the price impact.
- **Liquidity providers earn fees** but face impermanent loss.

---

### Traditional Order Book
![image](https://hackmd.io/_uploads/BJii0MjKkg.png)

