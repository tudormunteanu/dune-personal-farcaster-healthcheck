# Plan

Build a dashboard that gives an overview of one's Farcaster activity. Theoretically this should promote more engagement and more contributions to the community.

## Data to show

- [x] total casts per day
- [x] total replies per day
- [x] total likes per day
- [x] total recasts per day

- [x] longest thread contributed to this month
- [x] most replies created by you in a single thread
- [x] replies to cast ratio for the last month
- [x] flesh out copy on Dashboard
- [x] create mintable NFT on Zora
- [x] create visualizations for role-models
- [x] create twitter thread
- [x] channels in which you are most active


### Exercise 1

Given the following table scheme and sample data, 
table with sample data:
```CSV
fid, hash, parent_hash
1, 0x123, null
2, 0x456, 0x123
4, 0x789, null
6, 0x890, null
9, 0x135, 0x890
6, 0x246, 0x135
```

Write an SQL query to get the longest thread for a certain fid. Here are two examples:

1. longest thread for fid 9: the one started by 0x890, because it has 3 entries and has the following tree:

```
0x890
0x135
0x246
```

2. longest thread for fid 2: the one started by 0x123, because it has 2 entries and has the following tree:

```
0x123
0x456
```

### Exercise 2

Given the following table scheme and sample data, 
table with sample data:
```CSV
fid, hash, parent_hash
1, 0x123, null
2, 0x456, 0x123
4, 0x789, null
6, 0x890, null
9, 0x135, 0x890
6, 0x246, 0x135
9, 0x357, 0x246
```

Write an SQL query to get the highest number of replies created by a single fid (user) in a single thread. Here is an example:

1. highest number of replies created by a single fid in a single thread: 2 replies created by fid 9

0x135
0x357


## Launch copy

1/3 Have you seen this Farcaster Healthcheck Dashboard? 

It differs from most stats tools, because it focuses on the main driver for engagement: your own contributions. 

It also shows fun facts like your longest thread and how often you reply. Check it out: https://dune.com/tudorizer/personal-farcaster-healthcheck

---

2/3 Making this dashboard was fun. I dug into Farcaster data and found interesting patterns. It was exciting to turn raw numbers into charts that tell a story. Your story on Farcaster. I learned a lot about how we all use the network. 

It made me appreciate Farcaster even more.

---

3/3 Want to see your own Farcaster stats? It's easy. Just add your Farcaster name to the end of the URL. For example, to see @mats's dashboard, use this: https://dune.com/tudorizer/personal-farcaster-healthcheck?user_input_fname=mats

Try it with your name. You might learn something new about how you use Farcaster.


### Launch plan

Live at: https://dune.com/tudorizer/personal-farcaster-healthcheck

- [x] post on /farcaster; https://warpcast.com/tudorizer/0x7b63b1e6
- [x] post on /dune; https://warpcast.com/tudorizer/0x56829b2d
- [ ] write about it on /paragraph
- [ ] post on /build
- [ ] post on /data


# Post launch analysis

Response: 2/5 (solid below meh)

Why is it cool?
- mostly AI generated SQL queries + copy
- the underlying thesis that your contributions to a network are the lead indicator for good results
- the Dashboard lives forever (or as long as Dune is around)

Why it didn't work?
- the underlying thesis is too daft and maybe simple. "You cast more, you get more engagement, obviously";
- 2 users don't have Dune accounts;
- no "wow, look at this cool thing" factor;

Monetization potential: 1/5
