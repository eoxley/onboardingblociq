BEGIN;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b2cdd948-00f9-4918-8329-7e7b60a9b253', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.3', 'other', 'Insulation and Render (reaction to fire)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6c1d59a-8481-4c46-ad93-44d06e65fa76', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.4', 'other', 'Fire spread on external walls') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('41bc962c-29e2-4708-af44-4642e24cf013', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5', 'other', 'Other fire related construction detail requirements') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd28e37a-da6d-4705-a8e0-cf81acbeae8e', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5.1', 'other', 'All insulation types - As part of the fire performance requirements one fire resistant') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6c42c9b-4a8b-4dd9-b897-1b047afd41b8', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5.2', 'other', 'Cavities - Where cavities are present, they shall be separated by horizontal and vertical fire') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('450c35f1-cb04-4247-beeb-13e5c54300cc', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.1', 'other', 'PEWIRS will provide a weather resistant external wall insulation cladding to new and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('00c44a7a-8ee6-4778-bf8e-56b41c84c8c0', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.2', 'other', 'For timber frame and light gauge steel frame the systems shall comply with the appropriate') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('60827bfa-6db8-489a-a74f-8315a68bd49d', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5950', 'use', 'Structural use of steelwork in building respectively to ensure water penetration') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c74bf7aa-caa2-43df-b9ef-acbd6be19eb7', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.3', 'other', 'Where the wind driven rain exposure classification is very severe (refer to BS 5628-3 Code') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f8dd17b2-a425-478c-b22d-574aebe82f73', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2', 'other', 'Condensation Risk Assessment and Interstitial Condensation') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a1858eb6-fa56-4d97-8692-15df5072fb5d', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2.1', 'use', 'For PEWIRS used for dwellings the project designer shall determine the condensation risk') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('49c15e02-cd27-4b92-af6d-986acdc7d207', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2.2', 'other', 'The condensation risk assessment shall be carried out in accordance with BS EN ISO 13788') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('156072e2-8908-4978-bc98-a4192c23b45b', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3', 'other', 'Project specific condensation risk assessments are required for dwellings.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1d59f7e1-c136-4397-8f9f-7415cf3471f9', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.1', 'other', 'Advice on construction detailing for thermal insulation materials is provided in BRE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dabc42d9-4d42-453e-9ee7-2793df95f302', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.2', 'other', 'Steel and timber framed construction shall be designed to avoid the accumulation of') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f3bdf25f-8c2f-4788-b7cc-76c8836f6472', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.3', 'other', 'For steel and timber framed construction it is essential that any vapour control layer on the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b81384e0-ed9d-4687-96c7-3f87d186dd18', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1.1', 'other', 'The ultimate wind load to be resisted by the PermaRock Insulation and Render systems has') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9f0129fb-4cda-4f0f-a24c-efc97be956af', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1.2', 'other', 'The performance of the PermaRock Mineral Fibre system using the dynamic wind uplift test') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82e2de71-4fc0-41c0-87d8-71faa65dca37', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.2.1', 'other', 'The PEWIRS has adequate resistance to impact damage in situations other than those with') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('580096fa-dc6d-4a2c-a7b9-54b32762fab2', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6946', 'other', 'Building components and building elements. Thermal resistance and thermal transmittance.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ace6726e-0ef8-4288-b379-7808383f5a3a', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'U-value calculations, refer to BRE report BR 443 Conventions for U-value calculations') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6c94e99f-dc47-4e38-baa2-52292a1c709c', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'External wall construction details (from outside to inside)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('01441b4d-bc64-4bda-83c6-2a4efd62b0c9', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'Installation/Practical Application') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('99c21d50-b646-4790-bb6e-2625b88ce81a', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Conditions of Certificate Issue') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6c66f416-8862-484f-8009-022a2e63dcea', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a557f385-7613-4868-86eb-8e7de0e6a2ac', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('83ecbe5e-ccd5-4e93-8961-9d9bc6a84335', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('be9094a4-68fb-4233-85c7-ed83a12efbed', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'other', 'Substance or mixture classification') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ebe449c-3983-4dc3-806c-dfd66ffeaf6a', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'other', 'Regulation (CE) 1272/2008 (CLP) and subsequent amendments and adjustments.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('28a8e1e8-7f2c-422f-87f3-794e73f47e57', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'Description of first aid measures') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f44cc468-94cb-4454-a3f2-ed4ef9cbda66', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'Description of first aid measures (continued)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fc089935-e160-4488-8c7b-0b4f9da314b7', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'other', 'Most important symptoms and effects, both acute and delayed') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb373206-a6e5-4154-9d54-51cd64cac1c1', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'other', 'Indication of any immediate medical attention and special treatment needed') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b759beb9-01f5-477f-a078-df629f7a25ea', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'Special hazards arising from the substance or mixture') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c20d085d-4d41-41aa-9283-a7d4b10b74cb', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Advise for firefighters') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('076acc1b-a6fa-42e8-ac84-3d3e0d869788', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.1', 'other', 'Personal precautions, protective equipment and emergency procedures') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3d3dbc16-5b92-4730-8549-ad103a0eecea', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.2', 'other', 'Environmental precautions') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c0820388-dee7-4049-ae07-b0d1a9f5e58d', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.3', 'other', 'Methods and materials for the containment and the decontamination') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('447c43d7-3723-457a-92b3-eef3ccd652b8', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.4', 'other', 'Reference to other sections') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3717fecf-61ac-4213-be93-18381739ab93', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.1', 'other', 'Precautions for safe handling') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('745b7edd-8b0c-4f85-8979-1b7550a6c11e', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.2', 'other', 'Conditions for safe storage, including any incompatibilities') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de42f038-6a49-49e7-8b32-bb73e7f27471', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9.1', 'other', 'Information on basic physical and chemical properties') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ebbdf464-7666-4607-b6fe-00787000b945', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.3', 'other', 'Possibility of hazardous reactions') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('249a2762-eb53-429d-ba5a-931ac3ffa4b8', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.5', 'other', 'Incompatible materials') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('17dc49d4-0f1d-42f7-9012-c3ce2365107f', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.6', 'other', 'Hazardous decomposition products') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6048f095-551e-48cb-a134-7517a4341886', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.1', 'other', 'Information on toxicological effects') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('65ac0802-1e22-4756-b6aa-7fb3c8885c25', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.2', 'other', 'Persistency and degradability') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5c23dd16-4c22-4f38-8bf4-0f4ae97a40dc', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.3', 'other', 'Bio-accumulation potential') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd5114b0-299d-451d-8e10-3e810f63f589', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.5', 'other', 'Results of the PBT and vPvB evaluation') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8938dab9-cde3-4581-9990-915609a4f159', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.6', 'other', 'Other adverse effects') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5644d82c-3882-4582-8c3a-b5aa8ac5f3e2', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13.1', 'other', 'Waste treatment methods') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('033ccfaf-2d84-4ca3-9cb4-6fb589db0878', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.2', 'other', 'ONU’s expedition name') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('43fb9a60-1ace-4eac-92cb-a094bf622835', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.3', 'other', 'Transport hazard class(es)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e6b7562b-e236-4122-84ff-74307c0db0b5', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.5', 'other', 'Environmental hazards') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('802a7243-0a28-4c35-acfb-546133256a7d', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.6', 'use', 'Special precautions for user') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d07c0574-4c42-4320-ba9a-c6244f95e13c', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.7', 'other', 'Transport in bulk according to Annex II of MARPOL 73/78 and the IBC Code') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('81775498-249e-4df4-83ce-863b66b87b7a', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.1', 'other', 'Safety, health and environmental regulations/legislation specific for the substance or mixture') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c8a76e08-7022-4daf-8e24-ff0cef0d1ca9', '5f72e23c-6126-4a88-80f2-4f7e2c3cebc4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.2', 'other', 'Evaluation of chemical safety') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4479f696-6837-40c1-9b35-e83850924832', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '154', 'other', 'Putney High Street PO Box 732') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('614a8952-578e-4936-859d-ddbe1d0736bb', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'use', 'The development hereby permitted shall be carried out in accordance with the drawings and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b2742437-284b-4480-bc27-ec2b63ce95d3', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Except for piling, excavation and demolition work, you must carry out any building work which') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('29def3cf-595b-4d80-87cd-50a6d677557e', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'All new work to the outside of the building must match existing original work in terms of the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('199546da-42d1-4834-aa4d-df48a1ac1ee2', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'You must apply to us for approval of samples (including photographs alongside existing') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b8b8e155-4a01-41aa-b7b6-4943542fab39', '318580a2-47c5-4af4-a976-47b37c20bb22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'In dealing with this application the City Council has implemented the requirement in the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5f61941c-f19d-41ef-a4c4-60ce57e1320b', 'd5e3467d-d0cd-41d9-8de6-b8366b925f85', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'This permission fully meets condition(s) 4 of the planning permission dated 19th May 2020') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ff957c0-44a5-44c5-86d9-c47e0191d9bc', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3256fac6-c69d-40b2-9e98-8c90ded2f6ee', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('34b9b5fa-b036-4da5-9485-ffee66a8bf91', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4f97c5fb-13b4-423c-91b9-5c14f07b4c99', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1afc62bc-300b-46a0-907f-523c87dd4955', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bf64b4b1-1aea-4441-989f-7ebfd798bce7', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('630268a8-d265-41ba-a549-ff6af98efda2', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('420b0e8f-1e7e-47e2-8b82-bb715865fc9f', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6c04f88-f34d-44af-8ecf-9f120522fb94', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6848a5b3-3dd4-4c31-8bb2-f1b21f2ba749', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f4d7c678-956a-4132-a059-48851021959c', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d09d7189-50d7-4525-b1c6-8ac7419528da', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('017f40f5-12c8-4a8c-8aa3-b1b53d9b331d', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d9aaab1e-ea81-4987-aa06-fc4e108868a9', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e434890e-a20b-4af6-8dfa-e152b76b3ca5', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cf83bd11-2ce0-45c9-9698-24c04a6a7841', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('83d8e0a6-8e48-4d62-9548-a0483bd27810', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('811a1cb9-4cf5-4a89-8b53-913541d43089', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f85c7a0a-1d74-41dd-a057-ba11bf45cd20', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('502fcea6-ea6d-44f9-bac7-b5d02108d22a', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('df0785d7-6262-47f0-9a60-ea64ecad9682', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fe4e31b3-44fa-4246-933b-899284ab3471', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b726009a-9841-4079-ba00-767443a84566', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('217fb00f-d575-41c7-82f9-d6547606ac81', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c193d48f-8210-43a8-af41-e38ce8aa75e6', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('32e1844e-ece1-4e77-8e6a-1add50911cb8', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('99fadb50-6ee0-4531-b7a7-15c6cf9e09ba', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2dec5ec8-b6a7-466a-baea-337cdbd4947d', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4e3d9ff7-2790-4034-88c6-965ba8f72159', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21babbde-696b-4d89-8942-dca8ee059742', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d5d1c92c-ed31-428e-8bb0-4f3ce3d5793b', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ec574622-441f-4eab-b698-642d3b4a692d', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('eabf63ac-441a-4b99-a348-dfa027abbb21', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e5ffc78f-ad2f-4988-9214-656459d5a451', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8dd8362-f629-4dc6-870d-7de30e1ffb07', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0fc42fc6-591b-4ed1-a1e2-1910990b463c', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6fc831ce-80aa-4ca7-8949-c833c65fa1c8', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3594be86-abfd-4eae-b1fa-4295ffa24aa6', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ce160e4b-56a5-44ee-9fff-57a8f445a07a', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('47fb3046-2dd2-41e0-a7ad-cfaae3ded30c', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d4fa877c-0393-43e9-a68a-7b59506a09d7', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('eb9993e4-95a5-40cf-b96f-f6453c2b4841', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cc6e0a7e-73b7-4262-a286-7d9d1e48b322', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a74870c6-6c02-4cf8-8c8f-68ad86647b3f', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2c8f46a0-f2c8-43a5-a407-ba173cf50148', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('29d99378-b1da-4bc9-8565-0e7646c947d7', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('49137a91-d93e-4e7f-b8cf-828c52921868', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2d66e88a-66de-4fbf-b04a-302853c76554', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0e5fb1cf-d964-44db-9c0c-d78d6ed066ea', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c375619c-1fb4-49d3-9e44-5e628b3122d5', '58643923-21b5-449d-aa69-8402932465d7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('80acb5b6-6644-4a24-96fa-e9740c4758c6', 'd8279f13-85fb-454e-88a7-2ecd956e3c31', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('32c24ab3-c8f7-4b2c-a826-239740d3cce5', 'd8279f13-85fb-454e-88a7-2ecd956e3c31', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d53f2ee-7646-41cd-8c96-a33f93151292', 'd8279f13-85fb-454e-88a7-2ecd956e3c31', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0ccca2c4-aefd-4d44-93c9-b1a9ad09e397', '3a5c4f04-adcc-4a22-899b-e094176634d4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8e0b0676-2c60-4350-8daf-6bca68fa5b4e', '3a5c4f04-adcc-4a22-899b-e094176634d4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5661440f-7904-4f0d-8cd2-3e38b7dd0011', '3a5c4f04-adcc-4a22-899b-e094176634d4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0b4e5364-0abf-464c-9184-7762b20673e9', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de15d8b1-df08-43ff-b7df-0fc9f65e96f7', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('527fb857-d17d-4e1d-86a9-8e46be4f0afd', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b423f128-ff0b-42a2-8092-85db2ad3b09b', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('320f4e5e-2d57-44c4-ae27-bcd5cf605972', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21dd2892-d4de-49d7-879c-8097709493d9', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9144ee44-f5b2-4428-8349-0b58565d687c', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cdb641dd-fe75-4f5d-a4a9-33f138b0247a', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e10a3de7-1e77-4311-94c6-56f4190b2894', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4dfd7c56-c16d-4b73-bd78-53ca4a255974', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b0eb7b2e-162c-431e-9820-1e4c69f6ed49', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('88b4c706-9793-4587-85ec-de88441f8b18', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1978185b-4673-424a-8ce8-7a1a32868b70', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d26a9902-464d-425c-9587-095c14fe5531', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21ededea-6366-4ce7-bd79-6ae7770af04b', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af878dfb-5668-4d61-a447-5b8b9a8b2dd9', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b215db06-05c5-4a47-8df9-217115b488c8', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f443348f-f29a-4eb0-a343-bba922682f43', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cef79ae1-16ef-4697-a2d9-bfbbdd189929', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3dd861ec-ffc1-425b-9567-12919c825ebe', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('96b8a2f1-7043-4632-b253-338b8b3ff332', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('98be2d09-23e8-45c7-b42f-62601a5eccf6', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2d620d71-6c22-4c34-88e0-bcd103b8136c', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9da6f2c3-8b54-4c37-ae26-8a4849adcb40', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2887ddec-ff13-4963-b4a7-c0e8021b2154', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('da64d774-e884-4054-8abd-ffc02ab1263c', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d650a8f5-6f4d-47af-ba0a-8509173d035d', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1dd84785-1ed1-4e47-826e-cabef766169e', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d5ece361-12f4-4a3d-8cbb-5609ec114de7', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

COMMIT;