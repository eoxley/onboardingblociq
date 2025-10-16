BEGIN;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52b98df7-1057-48ec-ad07-ec1b972d9943', '4080b566-a5f7-44b9-a91a-ffb83795d3c4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fc7c2ab2-0a87-4ffb-9063-727b6f2da458', '563b2b9e-1fba-477f-820c-a4bee1c1d58a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b5074037-cfb5-4f03-b65c-e1525fc06af1', '563b2b9e-1fba-477f-820c-a4bee1c1d58a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('07d9f3d7-33ab-4422-a438-396d1776e277', '563b2b9e-1fba-477f-820c-a4bee1c1d58a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('16d96c51-44ae-4841-a173-ca6e795d76b4', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ad514cd8-a38f-4081-a8f8-e51df7eda686', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0d6462dc-fa7f-4dd3-b3a4-b96ba6b79edf', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('712d67b2-2ffd-4b7b-a2ea-f3b2f00ab5e0', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('49de959f-4194-4801-bbe3-0fd11b381afa', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8993b8ce-ccb6-44ee-9d4a-240b4f5b1f35', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7fa7b2af-8065-4847-a04d-c9a1c5a21da9', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66248836-acfb-4c5a-9da1-6d2c335e3e63', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('258a515a-2844-455e-bc22-9a7fc9cbda2c', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fcb73bf8-2a9f-4458-b2d9-ed9912e1794d', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('edd54221-976b-4848-bf27-8923774e2536', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a0c9138e-3cf3-49ee-a426-4bf189c82779', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa2b25c7-d50d-4114-9245-cc6d328a8603', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c047a4d1-1841-4bb6-a036-f647d42e6b5e', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('62d202ab-9cd7-4e4d-bebc-298d69b3a780', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f65ca89f-9a7c-4a10-8367-32e2c2bda6a9', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0036da1c-b7c2-44da-847b-4aeb776f5816', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0a51302a-9a99-4a6a-8b24-b6c9f250b1ae', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3bcbb51b-2d38-46d1-8a14-afdf63126cf2', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b0f0ae68-b00a-4ee8-91b8-ed5b06bfadc3', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('381f6c77-52bf-4b41-a0ed-256f39f556b4', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e9ee2ae4-5717-4473-9c38-478d42156d17', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('96592ab8-61a4-4249-ac3c-61e44bf462ce', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('be0dff61-7cc1-4b69-8efb-f29f46ef24b0', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('652048a6-1b34-4364-acbe-eb733aef55f5', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f71cb130-5410-4b7b-a65d-1403f2a70a9a', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c6570203-f186-4f25-9ecb-7662dabd5eba', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ce06bc78-1e36-452f-8db0-88d44fb7c88d', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('27cd95df-5f0b-408d-bcd6-9f21a128fea3', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1e1b9ffb-977e-45b0-9ea7-7a0e33b758fb', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c6ed16bf-65a6-490f-9d4d-e784f49b573e', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ec6692ea-cd84-4e48-8fab-7017eac36988', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ae165466-3e98-4ace-8cc5-83fafad51b31', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ad73684-f19d-47e7-86c0-f105c4671d7c', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8e5f426a-f6c3-4af1-ac93-f08b4e6d6957', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ba40bbe5-6fba-4907-a8b4-ab221ba34612', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('72d902f8-d42c-4923-91e1-274bdec5e6f8', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('488bd817-3c0d-49d8-838d-bdf563055f36', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82e371fa-5970-4ea0-a8bd-affa3a7251ca', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('271d2fb4-6b94-4b0a-8ca9-5f696e0eeabf', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0fb4b144-0e94-427c-b60e-238c8b472ed3', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f2a6bde9-29d9-48f7-8b66-76c742ec1874', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8425d3d7-ce99-466c-b41a-f61a3bfbdc79', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b1581f6e-ff36-45e7-ac6d-905378ff07c4', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7dc75351-3473-4383-9842-a38174b3c3d5', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a2351e0d-49ca-4df1-a02a-0f1d68bc7de4', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('db79ee36-c629-428a-9b9b-c30a1d7d54fb', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f940e5a3-069b-4706-bd27-d5c359e81175', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dbe7872f-cb5f-49b8-8f51-e965f55d1645', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ef35e7ec-dbc2-45f2-b18b-a647bcb24b83', '6ed02a28-2696-41ee-a91f-02accf8f26f6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d7c36b53-e59e-42e6-a367-513995a24274', '446ab34b-1f93-4ba7-82b0-6eea262e7f27', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66d43b67-fdb5-4ec8-bc56-8a7a3149b87e', '446ab34b-1f93-4ba7-82b0-6eea262e7f27', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f98f3e7a-2d07-4162-9cb3-b7f45c2c4c65', '446ab34b-1f93-4ba7-82b0-6eea262e7f27', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8037b4b8-107a-42f0-9aad-af4e8575cfdc', '08304154-2589-4d04-806e-67ae6f8a1764', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6fea3efc-7ade-4611-aad6-92e44e5e3e46', '08304154-2589-4d04-806e-67ae6f8a1764', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bab2ec08-28f3-4c45-84ac-bb01923f8992', '08304154-2589-4d04-806e-67ae6f8a1764', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e3cd05b5-a39e-4d18-9001-bab7d153300d', '0f489682-953d-429c-8860-18bc27cc6757', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('59157ba0-0f84-40e0-b521-67877848be6c', '0f489682-953d-429c-8860-18bc27cc6757', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a0516f96-df40-4cb4-b7d3-8ec229022b74', '0f489682-953d-429c-8860-18bc27cc6757', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('686a8518-62e2-4a81-940a-72398247913c', '91cfec3b-9b4d-4ff5-a7c7-35b8e310c222', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'use', 'Office 210 Devonshire House, 582 Honeypot Lane, Stanmore, Middlesex HA7 1JS') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0772201b-80f2-42af-8390-14177ff70530', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'The Customer therefore hereby agrees not to deposit in any Equipment and/or place for') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('04897800-a4ae-4cd6-a277-915e112836cc', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.1', 'other', 'The Customer shall have the care custody and control of the Equipment, whilst absolute title') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('16909a29-950b-4e6b-b17b-e4a770c685dd', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.8', 'other', 'The Customer shall not, unless with Westminster’s prior written consent place any name,') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('09c9f0c7-ac48-47af-95a6-edbcb58bce3b', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'repair', 'T he Agreement shall commence on the Effective Date and shall subject to early termination 8.1 The Customer shall at all times during the Term maintain with a reputable insurance company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7cf34674-6bc1-4352-9ea9-0d0e334b4bd3', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '8.2', 'other', 'The Customer shall, on demand from time to time, produce to Westminster such evidence of') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('425d4fa7-6b51-47da-a19f-1ba536be7dec', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'insurance', 'Services rendered by Westminster insurance as may reasonably be required.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7b1c11b7-4cd4-4fd7-a158-02755a93e205', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'other', 'Westminster shall provide the Services during the Term in accordance with the terms of 8.3 If the Equipment or any part of the Equipment is lost or damaged such as to be incapable of') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f814a877-aec2-41cc-9fc0-1bb21103324d', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'The Customer shall place all Waste Material in the Equipment and shall not place any terminate this Agreement by giving at least 14 days’ written notice to the Customer.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('faffd49b-58cf-466b-bb9e-5331b8f2b511', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'use', 'In the event that the Customer places Waste Material outside the Equipment, Westminster amounts described in Clause 13.2(a) and (c) below;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25dbe81e-d21e-46c4-a01e-24689a4d9b5d', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'other', 'The Customer warrants that it has absolute title to the Waste Material and has the right to (iii) to make available for collection by Westminster any part of the Equipment not so lost or') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66426124-0cbf-456f-9506-49be56f41ed8', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'The Customer shall bear full responsibility for the identity of the Waste that is deposited in') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d73ca289-3cd7-419a-888a-f27f88261303', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9.1', 'other', 'Any changes to the type, size and amount of the Equipment, or the type or frequency of the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa01a8bc-09f4-4133-893a-fd20ffa14b1a', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'The Customer undertakes that each Waste Transfer Note it completes in connection with') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('faa8a624-0b71-420e-bd90-0afa658f23de', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'The Customer shall ensure that prior to the Waste Material being placed in the Equipment Customer’s Location) within the area in which Westminster provides a collection service,') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f8119427-1cad-4cc9-8ced-c5b28182662d', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Westminster shall acquire absolute title to the Waste Material when it is loaded into') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2a9b5271-beb5-4d3a-aa1d-d2a31d183f92', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.1', 'other', 'The Customer shall ensure the Waste Transfer Note accurately records the Waste Material') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4d4bc1fb-5e9b-4021-80a0-4adf63789edf', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'Excluded Waste and Contamination') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6470047c-58ca-4092-9e53-a23ecf6f143e', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1', 'other', 'Unless the parties agree otherwise in writing in advance, the storage and collection of') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1a65c146-c3e3-4eba-9e13-c6597c125bac', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.1', 'other', 'The Customer shall pay on a monthly basis, or as otherwise agreed, for the services') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0b1cb990-22e8-40f7-a46d-e6cb830a20b0', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.2', 'rent', 'Payments shall be made in full by the Customer to Westminster within 30 days of the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('468bc180-f8de-4da8-b5ff-0abbd76ada48', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'other', 'Rate Adjustments No amendments to this Agreement shall be binding unless in writing and signed by the duly') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6af09e7-c314-4512-826b-9106f8872fb9', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.1', 'other', 'Westminster shall have the right to adjust the published charges and rates to reflect authorised representative of Westminster and the Customer and expressed to be for the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('78161c34-73d8-453d-9ee9-10eb43358635', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.2', 'other', 'Westminster shall have the right to increase such charges and rates, from time to time, 22 Waiver') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51b49f9e-4306-497f-b8e0-e27a4ab7cff1', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13', 'rent', 'Default in Payment and Termination In the event of any provision of this Agreement being or becoming ineffective or unenforceable,') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3985d335-a4de-4a4d-a037-6c63c362ea73', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13.1', 'rent', 'If the Customer shall be more than 30 days late in payment of the invoice as set out either in its entirety, or in part, this shall be without prejudice to the validity of, and shall not') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0a02f3f5-2c45-418a-89e1-c20fb356fa83', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13.2.1', 'use', 'If Westminster terminates this Agreement under Clause 13.1, the customer shall') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('12cda72c-9c58-474d-a4b8-3e1a7e1b14b1', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13.2.2', 'forfeiture', 'The Customer expressly acknowledges that in the event of termination of this This Agreement shall be governed by and construed in accordance with the laws of England;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9346d626-bed9-49fe-a986-d68667a5785f', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'other', 'Liability 29 Dispute Resolution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c5c78e35-9de5-401a-84d6-a76c957de1ca', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.1', 'other', 'Westminster shall not be liable to the Customer for any direct or indirect or consequential 29.1 If there is a dispute between the Customer and Westminster concerning the interpretation or') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3a27d310-98cb-4a8f-8b9a-7b0409ed85d7', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '29.2', 'use', 'If any dispute is not resolved within 10 working days of the referral under clause 29.1 (or such') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bc836dbd-4ea1-4b48-b1cb-2055b6daed5e', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.2', 'other', 'The Customer acknowledges being subject to the duty of care under section 34 of the force from time to time. To initiate the mediation a party must give notice in writing (the “ADR') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('912a1774-40df-4bb5-b1e3-ec6321fddcde', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '16', 'other', 'Indemnity in relation to Equipment 29.3 If the dispute is not resolved within 10 working days of the mediation then the parties may refer') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('939d7786-bfb6-4932-9ca2-88441e1e337e', '6245a204-c6ef-403b-9ccb-af47a2dd2198', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '17', 'other', 'Indemnity in relation to acts, defaults and negligence of the Customer') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3b359f76-7ef4-42b1-8980-9375376aab64', '739e4e4a-51ab-4cda-8672-5fc40250ce23', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '511', 'other', 'Watford Road, Chiswell Green, St Albans, Hertfordshire, AL2 3DU') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e39cf1a4-5d1b-4783-8792-6e3ee51a4bf4', '0bd35236-6699-4c3b-b697-0c27db2c70f3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'repair', 'Months Preventative Maintenance of the Fire Alarm System at Pimlico Place, as detailed in 1 2,087.00 2,087.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('698845fc-0001-4b6e-9d89-64c6ca67269b', '96a5b44e-4bb8-400e-ae71-c7433a83a485', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '21', 'other', 'February 2020 Our Ref: 11043//') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cb5865fb-784b-48ba-b4ee-db8fbd981498', '96a5b44e-4bb8-400e-ae71-c7433a83a485', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Stables Court, Orpington Kent BR5 3NL | www.fidelityintegrated.com') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('adf055f9-0276-4a27-ae45-0a6c75f02e49', '950254a8-5b7e-4462-9c79-e670aa5515f9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'repair', 'Six Monthly Fire Alarm Maintenance in line with BS5839: Pt1. per visit £240.00 £240.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4c042d6a-fd11-4fa6-9cb4-304bf3b463d1', '950254a8-5b7e-4462-9c79-e670aa5515f9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Standard Man Hours - 1/2 Hour £29.00 £29.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb7f934c-2d49-443d-a212-d48dfa6dc061', 'a102285d-b8ee-40df-b6e2-0f317f40f809', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Generator Contract 2022-2023 0.00 0.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('86ada4dc-2961-4140-83ca-7b8606a06391', 'a102285d-b8ee-40df-b6e2-0f317f40f809', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'repair', 'PowerCare Maintenance Contract - One Year Contract 795.00 795.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('57e6ab9b-af26-4667-8cd3-7d86b64a664b', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Employer (and/or plant owner) Network Homes') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('75f0ef44-6f22-4f61-81b4-15b3e9e89fbc', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Address NETWORK HOMES LTD') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('beca4511-33c7-44e3-84f2-9d08c703a19e', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'Address at which the Corner lift') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('43aa37e1-98a3-451e-9e81-b96886c24904', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'Description of Lifting ELECTRIC PASSENGER/GOODS LIFT (FIREMAN LIFT)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ac4895a-b7f8-454c-bd4a-4493f628fa01', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'Nature of Examination Thorough Examination carried out within an interval of 6 months under Regulation 9(3)(a)(i) unless') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('50eb54b7-ab61-418f-92f5-1a02958b749c', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Identification of any part found None.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('461185f9-5210-485f-8a16-65fba7343d98', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '8', 'other', 'Observations and condition of Suspension belts are worn, but remain serviceable.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cf6cf9ea-3855-4550-aa3c-95889355f8b7', '9db10494-5e92-41ca-9d0d-be69461a6da5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'other', 'Date of last thorough 02/09/2020') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('76a26b29-f81d-458a-b5e4-21500f3ac030', '57bc2048-a53a-4ec8-b480-570613ac17b0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3566', 'other', 'Pimlico Place 21 Jun 2024 600.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d8141e9e-0cba-47fa-848f-c96d8bd31b64', '1fcc77fc-b84c-47d9-9300-1404944e2684', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Overspeed governor rope £460.00 £552.00 £3,312.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e5ea8a43-181e-42b7-a361-27930fb1b28e', '1fcc77fc-b84c-47d9-9300-1404944e2684', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Counterweight overspeed governor £460.00 £552.00 £3,312.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d3006bd-19ca-44c2-b624-0a67d06384a0', '103cd843-5a84-426a-bfe4-6bd415838055', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'LIFT 2 BLOCK C - TECHNICAL £550.00 £110.00 £660.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d4512ea1-4d88-4f80-a99d-4b527ca3aee8', 'e85eb392-86cc-4035-8b22-61f1dff9d500', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c235ce7-b014-4158-a721-4375c5b5fb0f', 'e85eb392-86cc-4035-8b22-61f1dff9d500', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('648169d9-ba04-40f8-9d33-1c2b2f7a0ef8', '9f2ff369-1493-4144-bfbf-61a2a346fb87', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('99a1e6f3-5ab3-4d7e-a094-c7a0d19691b3', '9f2ff369-1493-4144-bfbf-61a2a346fb87', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('795b589f-2ab1-4f1f-905d-130dde699050', '47a74b03-ee8c-4d0c-ab70-b3f211f238b8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('96ce1704-fc15-4fc0-b525-4814defcee3e', '47a74b03-ee8c-4d0c-ab70-b3f211f238b8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b670116c-c9e6-4d61-b3e9-a1190fc7ff64', '7b5597fb-9fc5-47ea-b103-990a2d32aa3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fc403f18-2aaa-4e82-bfc9-1f3177ba9f14', '7b5597fb-9fc5-47ea-b103-990a2d32aa3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f5c56725-2d45-445f-a2b2-ac3e56bbcf7e', '71126a23-cffb-4eee-8799-42de128df70b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3eb72792-bd03-4759-966c-57b492aea633', '71126a23-cffb-4eee-8799-42de128df70b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5e832f4e-aeab-4c60-8366-51a4ca74a6c1', 'bd0b6a9d-ef9b-4047-9c68-ef5b29969b33', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ecd909c7-3330-464e-ac29-d1c63bc0045b', 'bd0b6a9d-ef9b-4047-9c68-ef5b29969b33', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b3f6e516-ede0-42cf-b4ca-b2f2d805466d', '7b6966c7-35c6-41a7-8fa0-5b5f0a5b15fe', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dff0d080-2bfe-47ef-82f6-3bb8aa25ed1e', '7b6966c7-35c6-41a7-8fa0-5b5f0a5b15fe', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6f9a297f-189f-4022-a4c7-32811e33fd9d', 'dc2ef695-862d-4276-98e9-5dda30a40512', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('16810a50-3f95-4af5-b0fb-867aecefb1c4', 'dc2ef695-862d-4276-98e9-5dda30a40512', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9202b724-5f72-460f-987b-005823c853c4', '66bca7c2-124f-4756-883f-6bb12c5c4e76', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a2e697e3-a437-4834-a0f3-e64ecda4cdcd', '66bca7c2-124f-4756-883f-6bb12c5c4e76', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('97e03742-3336-4a61-9090-2d3b8d35b5ae', 'e5c753b5-ea5d-4d2a-9e28-9d778042c2d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b853b0d2-8b89-49a1-b2d7-0fa22bdcbceb', 'e5c753b5-ea5d-4d2a-9e28-9d778042c2d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8f9c0bfd-29a4-40f5-a4fa-895deaa72173', '85eadd8e-4e1d-41a7-a55f-abfc68257ab8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('18ef98f3-a5d1-4c8a-8a5f-86a9e3290588', '85eadd8e-4e1d-41a7-a55f-abfc68257ab8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fd1a5d66-c30f-4213-870e-90d812c346a4', '5c76bcb4-1977-4322-81df-029ec096aa39', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d8ba8a9-684c-4855-8d95-e7ac9dc8ce87', '5c76bcb4-1977-4322-81df-029ec096aa39', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5f792311-6869-4b89-9ac2-2edbcd0a321f', 'fea1c428-5524-4406-a736-8e1d53088601', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('075ee039-1eff-4a01-9282-00dac39eaa53', 'fea1c428-5524-4406-a736-8e1d53088601', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4ececa05-f705-4380-bc45-f3ab75e6fcc6', 'eaae6dfd-197e-4b0c-9bae-ebb868edae98', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b075d3ad-1500-405a-8fe5-980950222dd8', 'eaae6dfd-197e-4b0c-9bae-ebb868edae98', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('235892d5-8de5-461c-b61e-aa77262b5633', 'e83ba155-01ec-498f-ada9-7ece1b44627f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bbd55b84-1584-4011-8b20-028cfd2a7350', 'e83ba155-01ec-498f-ada9-7ece1b44627f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('127d79a0-fcbf-441a-821f-c9566b2b5ff6', '7af48ec8-15a6-4f0a-a0f7-83d64067c563', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d651b978-20ef-4244-a314-fa1919537c0a', '7af48ec8-15a6-4f0a-a0f7-83d64067c563', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '07', 'other', 'Has the lift been left in service?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('181e9503-2496-4b60-ae41-029c52aa64c7', '5647d3ed-64dc-4ea6-8a2e-fcae520c07f7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '28', 'use', 'Guildhouse Street RESOURCE') ON CONFLICT (id) DO NOTHING;

COMMIT;