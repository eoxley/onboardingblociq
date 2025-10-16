BEGIN;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('98dd3fd0-b2f2-4117-a96f-b0cab8adc752', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ef703f20-7644-4dcc-906a-f6ac6893ef08', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a7c0ba88-d553-4b32-b7b8-29da5191c044', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e8fb0cc4-3396-4d94-9e53-c4372367c398', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f90a5d07-2fa7-48fc-a412-708ca36a2a69', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6ff94e98-d4f6-465a-adc1-e274e385b9b5', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('621c9bf8-6076-4924-8ebc-2409308a6a4b', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ad45757-8a67-45b4-8a7c-5690f2c2cbf6', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a3f8d116-bda1-4ef6-bac8-bdee906802b8', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25a84808-07e5-4e61-8d9d-7c45fe036e8c', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f149ce03-b5ba-4493-a47e-64571beb6dcc', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ac4a9ee-cf29-4a4a-9c7b-8a3bd7a1e94d', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4868f33a-86b0-478d-9ce5-ffcb7d45a4b3', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c62ab4c4-9e21-4b4f-9b73-56c89d6a1d0f', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e11c1a90-79ba-4fe9-ac53-15f5c6ffdc67', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3a98bca9-4903-46b6-ad93-6a1e18097058', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b53e963a-03d6-4f55-8817-27615a1f719c', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c60fa8b8-f57b-4ee6-884a-fc566bdc8869', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de87888c-c8c3-4ce7-a872-9beea9fc8656', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d872265-a224-4548-ae90-0b644c5ea4cf', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('05de1a2e-afdb-4a1b-a111-f36b8816a3a7', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('45d19296-b485-4964-a3e4-1862d0f31e23', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a94a01e1-8892-49fb-ae61-90cbb53f0535', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9f7bae0e-61ce-4ff4-b654-6b774e8c3931', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f0e5d8dd-55ac-4650-a8d5-b1ac90869bf1', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('94b23bb7-65a6-4c50-94ea-557751ba4ba3', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa002f6b-f949-4d58-ab44-8afcd10388cc', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('62f98839-9394-4e98-af42-c08df118ab11', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b7a9fcc-dfd7-4782-b50f-c0aff99cab7d', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f8f524a6-d2b9-4ef7-b8b8-01086d7282fb', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('01de0c02-4a3e-447f-923d-33fbe7d889e2', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fde64a5e-dfa0-408b-9446-5b2fe8c81912', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('55e327f0-4c38-496c-82ba-90490ca7219c', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2fd6e516-2fe8-4a38-b0c4-739cd1784ad9', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de9394ff-ad17-4e2f-81fa-0a99caaa9117', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79b6a60d-e599-4de2-8885-ea9f0f5a18af', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('debb1e92-948e-4f20-b9b8-4c8673f4d24a', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ac1b6a7-da14-49cd-9a9d-72dc1d62ed69', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('72919008-bcae-4ea8-a255-ebaea96d4975', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('beec6322-667e-4af0-8bee-f1a8930ebab6', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fff42d30-742b-4ee0-a2f6-dca89f1399e1', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a53b5c10-3fd3-4d80-9894-08e0a914966a', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6950e3da-c264-4149-9d5f-aede14c6f1ff', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e0446ac3-db51-4ea6-a102-d8d1b57799e1', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b2262176-3b77-46ed-afe8-f0e56e020a05', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0ac2577a-80d8-44d3-b4fb-79e75d4617c2', 'dfa2c095-97a0-4497-a63c-4394ec3910e9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e32474f-f933-46a8-abfd-d7bd1c494f33', 'a3c2bc2d-fe6e-4a9b-93a4-dd893f81ae70', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2021', 'other', 'Building Regulation requirements in relation to fire safety') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f515e750-0b7b-40f5-b518-ca4a761f3922', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('626f72dd-47de-4e2a-ae58-b492634195f0', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb35df17-26b4-4e1c-833b-7827fbf661ab', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c333bc81-d059-4ee9-a7a7-46bbacb57e39', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd907b63-85fe-45b6-95ae-92e89169df41', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d11e92aa-7324-48bd-ae39-7d9a910e32bf', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9f6da22d-1839-45ac-afba-0e22a0abea38', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b160e38-f450-430c-8db7-5f4aa59c4abe', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0310220b-cd6f-4c3b-8abe-3780f8b51221', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7bc218ad-1e0a-43f0-a487-fe5455b29e6c', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('695554d5-0091-4d3a-9a9a-bbfe9b7d64ae', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bdee88a9-9803-4c46-8fbc-850e2b52e54a', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('91895f4c-5e61-4fcc-968b-6c8fde02b2a1', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9fe58d9a-f999-4cf4-b590-62ae79d01769', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2cd2feca-023e-4b24-9523-ec90df2491ad', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('347ff972-943c-426d-a9b0-419be651da05', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('84a4c255-05f6-482c-804d-be2d198ec2c7', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02c0fbd6-8cc5-4ef4-9c64-e30d1dd9bead', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1acd4cef-5557-4ed9-a286-b7ba3a2961bb', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('72dabd1c-2b09-43a0-bdbc-4cfc2c3f1608', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5eb811b3-ed3c-4650-8a23-a4f33c1bbf17', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8dc5e86-5a2f-43b9-84fc-7ba9709ce213', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('023e966a-eb21-489a-bb72-72a38cbc4372', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d9eab048-51af-4ed4-aa16-d4515ea04b9e', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c54a51d2-b401-4028-a102-f54017cf45f9', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b56a607-9104-468e-a2f4-b4fb5caf980d', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b20c378a-b49d-4f46-8c29-a6a127b987f1', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4538b77d-744a-481d-a448-afddda209d70', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3c35f120-3f89-4ff4-9588-b4ca6dea24a7', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('13eabe8d-8ea0-411c-8434-3c14a309d0a3', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9e28e851-3995-41f1-a157-774b954b439d', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dd6ad417-fee7-400a-8bec-f5d49a86204b', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5763adc9-d977-44a6-ab2e-84f94de3764f', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('97ab460a-543b-4dc9-bab1-da5bcb83146b', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1cc2c202-d9f5-4610-ba3d-647e881fd01e', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5a0f1ffc-6437-4a29-ba18-90543137a752', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b7ca3784-78a7-4977-9bd9-e49cec6bf520', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3edd5fc9-498a-4116-9b18-e0a748cdb023', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2cc319ce-c8e4-4db1-848b-e09bf70363e2', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('da680ebd-8aa5-4389-ae6d-89881cda0a08', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f6a1f665-1e7c-4cd8-a692-86feaaec4831', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2fd6319c-bdb7-4adc-8146-b9a9df0ba667', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6540794e-6d5f-4971-905d-b59edcb2b44a', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3adb0f93-1c88-492d-a07a-3ce02f7826b9', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('27d00ad7-9907-4c15-b3b5-a8c3e7ff069e', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e7c66d90-2646-472c-8a33-94de97a3ba9e', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('942bcd60-f67a-47ff-8893-2722d8176e79', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ca3e6767-0d70-4073-94f7-36ae91942a6a', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6551a39c-3ac2-45d7-a43d-3029ab80de24', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('104e69a3-625e-4361-800c-e69104407c36', 'bfcf74a0-fbdc-4cc8-854d-cd4efcf76765', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('961f79a7-8f5f-4e2f-aa87-467a90640999', '4d69629c-f580-4503-8f00-3f6114a9e9ed', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14', 'other', 'February 2017 (para (5)(e))') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f3f52092-a869-4a57-98f7-f5c0ee248e97', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bdd6ee0e-a3f4-4d08-98b6-4185058bbaa1', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('681efb8a-5b35-4356-8491-b87440fb1be2', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1a5e4391-ec60-48a8-9374-16e6f4fe2eb2', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2a333aa4-5ce5-44fa-a124-e97d0beae3e4', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0432eefc-a5f5-4257-bbcd-f33ac8d27894', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f3103dc4-ccba-40b8-9773-5b0408e13139', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e356331f-2380-4bcf-a190-660be9f5e919', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('58d222d4-fba5-421e-aad7-fd2988ff7574', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82af669e-3beb-4e59-9b40-c0866ef52f45', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('26861ef9-c757-4051-841f-9e829643b487', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ddb3e7f-5838-4327-a2f0-974e46297330', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c59a7d13-1b84-43e5-a183-8a6a61f22473', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8036ad2b-4592-4072-a059-40bbc7d2892d', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ffdee59f-d6e8-4dd1-aac4-e58ec01308ea', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63f8caf8-46fe-4533-9d07-e7a06a529c09', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('95b7e999-cfda-4b46-8ae8-a23675afec56', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52e78aae-2537-490d-b826-874318809346', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cf24e1f3-5de7-4b0e-8c38-f45cb18e2cf5', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3fd22aa0-edb6-401f-9ca9-4a7a49736a40', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e1dee3f5-36e6-4192-b94c-5eb8dd57e7c9', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('eb03a0f4-89c4-4d58-bfd4-1329f8fb8e1d', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e1a9fe3-f4a0-4b9e-8f0f-f106e510fa24', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cb81df92-0715-4fe0-8912-078c89fbe6d5', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9593a953-13dd-4664-9453-3635b105c879', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b84b11b8-b189-44f9-8e7e-5101eb32bbb1', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('28f12079-0e9e-40c3-b0b9-2c6560b17309', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('09cda3be-f90b-4bb4-84ce-6ee1c1c35da0', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f411b81c-727c-4b34-8c9b-1513c1ef9f19', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1bed745d-729f-4c26-a7b1-70392f1d3eb8', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('13fcc55d-b585-4f20-b549-727179e1b3a4', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('00b6d9c1-d4ef-4e8b-805c-3b264bb0184b', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('114c5733-5c4a-4e0c-aa91-24635413e637', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5daf1653-dd60-43e8-a6ec-e2a0a26a44cd', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fb7ec251-ea81-4291-8426-64bd7300482f', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b24f44e2-abc5-482b-a7e7-fc380fb7be35', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7bd4f497-29dd-4ea2-9edc-3ed2ebfbf9eb', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('26e6367c-be54-43ef-ac29-54dc08d5887b', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82adca84-86b9-4e9b-9be4-cdc58ade9107', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f04355c4-f5b2-4c32-ad2d-d2234ce051ee', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f67c4d4a-4f06-42ef-b71e-c99c8724df03', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b83ebf92-40f1-439d-8ca3-58a1af73491f', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c1d43c1-79fb-461b-9312-92bc1175bf90', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2f0a10c4-5083-4b72-b8ff-b30517935705', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('18f46232-a30d-4e63-ba61-299024cbf25e', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c6fc4a8f-2ac9-40e7-bded-415824eb5979', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ee9ec72d-0b32-46ee-864a-132d1cfb8047', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b44a8be-f01c-420d-80b8-ec0e16329761', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7e83da94-6322-42ba-9198-13a0709002a3', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e614cbe3-fee5-47be-8f60-7d78481f3369', '6c2dbc4d-7d4f-402f-8538-a05a2aa5d52f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5953fa62-7dea-4e62-a319-5951fad5d28d', '4080b566-a5f7-44b9-a91a-ffb83795d3c4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4cbf43ec-08ee-4aa7-a9e2-c00fd3ac9ac5', '4080b566-a5f7-44b9-a91a-ffb83795d3c4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

COMMIT;